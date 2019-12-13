#!/bin/bash

#   ***************************************
#   *                                     *
#   *     Build Script for SunEngine      *
#   *        Script version: 1.4          *
#   *                                     *
#   ***************************************


#Include variables
source SUNENGINE


# Set folders paths
unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac;;
    CYGWIN*)    machine=Cygwin;;
    MINGW*)     machine=MinGw;;
    *)          machine="UNKNOWN:${unameOut}"
esac

if [ $PROJECT_ROOT == "auto" ]; then
  {
  if [ $machine == "Cygwin" ]; then
    PROJECT_ROOT="$(cygpath -w $PWD)"
  else
    PROJECT_ROOT="$(PWD)"
  fi

  SERVER_PATH="${SERVER_PATH/auto/$PROJECT_ROOT}"
  CLIENT_PATH="${CLIENT_PATH/auto/$PROJECT_ROOT}"
  CONFIG_PATH="${CONFIG_PATH/auto/$PROJECT_ROOT}"
  BUILD_PATH="${BUILD_PATH/auto/$PROJECT_ROOT}"
  }
fi

echo -e "\n${GREEN}Building \"${PROJECT_NAME}\" project. ${NC}\n"

echo -e "${GREEN}Using variables ${NC}\n"
echo -e "${GREEN}PROJECT_ROOT = ${PROJECT_ROOT} ${NC}"
echo -e "${GREEN}SERVER_PATH = ${SERVER_PATH} ${NC}"
echo -e "${GREEN}CLIENT_PATH = ${CLIENT_PATH} ${NC}"
echo -e "${GREEN}CONFIG_PATH = ${CONFIG_PATH} ${NC}"
echo -e "${GREEN}BUILD_PATH = ${BUILD_PATH} ${NC}"



cd "$PROJECT_ROOT"

echo -e "\n${GREEN}Deleting old build ${NC}"
rm -r "$BUILD_PATH"
mkdir "$BUILD_PATH"

# dotnet build
if [ dotnet > /dev/null ]; then
{
    echo -e "\n${GREEN}Building server ${NC}\n"
    if ! dotnet publish --configuration Release "$SERVER_PATH/SunEngine.Cli" --output "$BUILD_PATH/Server"; then
    exit 1
    fi
}
else
    echo -e "\n${RED} .NET Core not install."
    exit 1
fi


echo -e "${GREEN}Building Client ${NC}\n"

cd "$CLIENT_PATH"

# install node_modules
$NPM_UTIL install

if [ ! -d "$CLIENT_PATH/src/site" ]; then
  echo -e "${GREEN}Copying $CLIENT_PATH/src/site.template => $CLIENT_PATH/src/site ${NC}\n"
  cp -r $CLIENT_PATH/src/site.template $CLIENT_PATH/src/site
fi

#check on available quasar
if [ ! quasar > /dev/null ]; then
    echo -e "\n${RED} Quasar not install please install by command\n${BLUE} npm install -g @quasar/cli ${NC}"
    exit 1
fi

echo -e "\n${GREEN}Building Quasar ${NC}\n"

# quasar build
if  ! quasar build; then
    exit 1
fi

# copy dirs and files

echo  -e "\n${GREEN}Copying Client to wwwroot directory ${NC}"
cp -r "$CLIENT_PATH/dist/spa/." "$BUILD_PATH/wwwroot"

echo  -e "${GREEN}Clearing dist directory ${NC}"
rm -rf "$CLIENT_PATH/dist"

echo  -e "${GREEN}Copying Config to build directory ${NC}"
cp -r "$CONFIG_PATH/." "$BUILD_PATH/Config"

echo  -e "${GREEN}Copying Data to build directory ${NC}"
cp -r "$PROJECT_ROOT/Resources/." "$BUILD_PATH/Resources"

echo  -e "${GREEN}Copying .SunEngineRoot file ${NC}"
cp  "$PROJECT_ROOT"/.SunEngineRoot "$BUILD_PATH"/.SunEngineRoot



echo  -e "\n${GREEN}All done! ${NC}\n"
