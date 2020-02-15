#!/bin/bash

#   ***************************************
#   *                                     *
#   *    install and update SunEngine     *
#   *        Script version: 0.1          *
#   *                                     *
#   ***************************************


DIRECTORY=""
PGPASS="postgre"
PGPORT="5432"
PGUSERPASS=`head /dev/random | tr -dc A-Za-z0-9 | head -c 16`
HOST="localhost"
SILENT=false

#region разбор параметров

while true; do
    case "$1" in
        -h | --help )
            echo "    -h, --help        Информация о командах";
            echo "    -d, --directory   Путь к папке установки";
            echo "    -p, --pgpass      Пароль PostgreSQL от юзера postgres";
            echo "                      (какой сейчас установлен или какой поставить при установке PostgreSQL)";
            echo "    -P, --pguserpass  Пароль PostgreSQL от пользователя от оимени которого создается БД (значение ключа --host)";
            echo "                      (значение по умолчанию 16 случайных сииволов, задавать вручную только когда пользователь уже создан)";
            echo "    -H, --host        Домен либо ip";
            echo "    -s, --silent      Установка без участия пользователя (на все вапросы отвечать да)";
            exit 0;
        ;;
        -d | --directory )
            DIRECTORY="$2"
            shift 2
        ;;
        -p | --pgpass )
            PGPASS="$2"
            shift 2
        ;;
        -P | --pguserpass )
            PGUSERPASS="$2"
            shift 2
        ;;
        -H | --host )
            HOST="$2"
            shift 2
        ;;
        -s | --silent )
            SILENT=true
            shift
        ;;
        -- )
            shift
            break
        ;;
        * )
            break
        ;;
    esac
done

SILENTINSTALL="debconf-apt-progress -- "
if $SILENT
then
    SILENTINSTALL=""
fi

#endregion

if (( $EUID != 0 )); then
    echo "Поскольку скрипт использует apt то нужны права администратора" 1>&2
    exit 100
fi

# Узнаем данные о системе на которой нас запустили
# имя дисрибутива
distr=$(grep ^ID /etc/*-release | cut -f2 -d'=')
# версия дистрибутива
version=$(grep ^VERSION_ID /etc/*-release | cut -f2 -d'=' | sed -e 's/^"//' -e 's/"$//')

# ставим "зависимости" скрипта
$SILENTINSTALL apt-get update
$SILENTINSTALL apt-get -y install wget apt-transport-https dpkg

# Окно ошибки
Error() {
    if $SILENT
    then
        echo "$1 $2"
    else
        whiptail --title "$1" --msgbox  "$2" 10 60
    fi
    exit 0
}

#region dotnet

dotnetPackageName="aspnetcore-runtime-3.1"
dotnetVersionName="Microsoft.AspNetCore.App 3.1"

# Добавление репозиториев Microsoft для dotnet
addDotnetRepo() {
    case "$distr" in
        "debian" )
            if [ "$version" != "10" ] && [ "$version" != "9" ]
            then
                noSupportError "dotnet" "dotnet не поддерживает $distr $version а значит SunEngin запустить не получится"
            fi
            # добавляем репозиторий
            if ($SILENT || whiptail --title "dotnet" --yesno "Для установки dotnet нужны репозитории от Microsoft.\n\nДобавить репозитории?" 11 60) then
                wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.asc.gpg
                mv microsoft.asc.gpg /etc/apt/trusted.gpg.d/
                wget -q https://packages.microsoft.com/config/debian/$version/prod.list
                mv prod.list /etc/apt/sources.list.d/microsoft-prod.list
                chown root:root /etc/apt/trusted.gpg.d/microsoft.asc.gpg
                chown root:root /etc/apt/sources.list.d/microsoft-prod.list
            else
                exit 0
            fi
        ;;
        "ubuntu" )
            if [ "$version" != "16.04" ] && [ "$version" != "18.04" ] && [ "$version" != "19.04" ] && [ "$version" != "19.10" ]
            then
                noSupportError "dotnet" "dotnet не поддерживает $distr $version а значит SunEngin запустить не получится"
            fi
            if ($SILENT || whiptail --title "dotnet" --yesno "Для установки dotnet нужны репозитории от Microsoft.\n\nДобавить репозитории?" 11 60) then
                wget -q https://packages.microsoft.com/config/ubuntu/$version/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
                dpkg -i packages-microsoft-prod.deb
                if [ "$version" = "18.04" ]
                then
                    add-apt-repository universe
                fi
            else
                exit 0
            fi
        ;;
        * )
            noSupportError "dotnet" "dotnet не поддерживает $distr $version а значит SunEngin запустить не получится"
        ;;
    esac
    echo "добавлены репозитории Microsoft в /etc/apt/sources.list.d/microsoft-prod.list"
    $SILENTINSTALL apt-get update
}

# Установка dotnet нужной версии если таковая еще не установлена
checkDotnetVersion() {
    if ((! echo `whereis dotnet` | grep "/usr/bin/dotnet" > /dev/null)
    && (! echo `dotnet --list-runtimes` | grep "$dotnetVersionName" > /dev/null))
    then
        if ($SILENT || whiptail --title "dotnet" --yesno "$dotnetPackageName не установлен, установить?" 11 60) then
            $SILENTINSTALL apt-get -y install $dotnetPackageName
        else
            exit 0
        fi
    fi
    echo "$dotnetPackageName установлен"
}

# репы мелкософта добавлены?
if [ ! -f "/etc/apt/sources.list.d/microsoft-prod.list" ]
then
    addDotnetRepo
fi

#проверяем установлен дотнет или нет
checkDotnetVersion

#endregion

checkPostgreSQLVersion() {
    if ((! echo `whereis psql` | grep "/usr/bin/psql" > /dev/null)
    && (! echo `psql --version` | grep "(PostgreSQL) 11" > /dev/null))
    then
        
        if ($SILENT || whiptail --title "PostgreSQL" --yesno "postgresql-11 не установлен, установить?" 11 60)
        then
            $SILENTINSTALL apt-get -y install postgresql-11
        fi
    fi
    echo "postgresql-11 установлен"
}

checkPostgreSQLVersion


# проверяем существование БД
if (su - postgres -c "psql -l -At" | grep "^$HOST|" > /dev/null)
then
    if ($SILENT || whiptail --title "PostgreSQL" --yesno "Обнаружена БД скорее всего она осталась от предыдущей установки, удалить?" 11 60)
    then
        su - postgres -c "dropdb $HOST"
    fi
else
    ddd=$(su - postgres -c "psql -c \"CREATE USER \\\"$HOST\\\" WITH PASSWORD '$PGUSERPASS';\"" 2>&1)
    if [ "$ddd" != "CREATE ROLE" ]
    then
        DBUSERPASS=$(whiptail --title  "Пароль $HOST" --inputbox  "Введите пароль от для PostgreSQL пользователя $HOST" 10 60 Wigglebutt 3>&1 1>&2 2>&3)
    fi
    echo "нету"
fi

    su - postgres -c "psql postgresql://postgres:$PGPASS@127.0.0.1:$PGPORT/$HOST << EOF
       CREATE USER davide WITH PASSWORD 'jw8s0F4';
EOF"

