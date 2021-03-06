export default {
	ImagesCleaner: {
		GetAllImages: "/Admin/ImagesCleanerAdmin/GetAllImages",
		DeleteImages: "/Admin/ImagesCleanerAdmin/DeleteImages"
	},
	CypherSecretsAdmin: {
		ResetCypher: "/Admin/CypherSecretsAdmin/ResetCypher"
	},
	UserRolesAdmin: {
		GetRoleUsers: "/Admin/UserRolesAdmin/GetRoleUsers",
		GetUserRoles: "/Admin/UserRolesAdmin/GetUserRoles",
		RemoveUserFromRole: "/Admin/UserRolesAdmin/RemoveUserFromRole",
		AddUserToRole: "/Admin/UserRolesAdmin/AddUserToRole",
		GetAllRoles: "/Admin/UserRolesAdmin/GetAllRoles"
	},
	RolesPermissionsAdmin: {
		GetJson: "/Admin/RolesPermissionsAdmin/GetJson",
		UploadJson: "/Admin/RolesPermissionsAdmin/UploadJson"
	},
	MenuAdmin: {
		Create: "Admin/MenuAdmin/Create",
		Update: "Admin/MenuAdmin/Update",
		SetIsHidden: "/Admin/MenuAdmin/SetIsHidden",
		Delete: "/Admin/MenuAdmin/Delete",
		Up: "Admin/MenuAdmin/Up",
		Down: "Admin/MenuAdmin/Down",
		GetMenuItem: "/Admin/MenuAdmin/GetMenuItem",
		GetMenuItems: "/Admin/MenuAdmin/GetMenuItems"
	},
	SectionsAdmin: {
		AddSection: "/Admin/SectionsAdmin/AddSection",
		UpdateSection: "/Admin/SectionsAdmin/UpdateSection",
		DeleteSection: "/Admin/SectionsAdmin/DeleteSection",
		GetAllSections: "/Admin/SectionsAdmin/GetAllSections",
		GetSection: "/Admin/SectionsAdmin/GetSection",
		GetSectionTemplate: "/Admin/SectionsAdmin/GetSectionTemplate"
	},
	CategoriesAdmin: {
		CategoryUp: "/Admin/CategoriesAdmin/CategoryUp",
		CategoryDown: "/Admin/CategoriesAdmin/CategoryDown",
		GetAllCategories: "/Admin/CategoriesAdmin/GetAllCategories",
		UpdateCategory: "/Admin/CategoriesAdmin/UpdateCategory",
		CreateCategory: "/Admin/CategoriesAdmin/CreateCategory",
		CategoryMoveToTrash: "/Admin/CategoriesAdmin/CategoryMoveToTrash",
		GetCategory: "/Admin/CategoriesAdmin/GetCategory"
	},
	CacheAdmin: {
		ResetAllCache: "/Admin/CacheAdmin/ResetAllCache"
	},
	SkinsAdmin: {
		GetAllSkins: "/Admin/SkinsAdmin/GetAllSkins",
		GetAllPartialSkins: "/Admin/SkinsAdmin/GetAllPartialSkins",
		GetSkinPreview: "/Admin/SkinsAdmin/GetSkinPreview",
		UploadSkin: "/Admin/SkinsAdmin/UploadSkin",
		UploadPartialSkin: "/Admin/SkinsAdmin/UploadPartialSkin",
		ChangeSkin: "/Admin/SkinsAdmin/ChangeSkin",
		DeleteSkin: "/Admin/SkinsAdmin/DeleteSkin",
		DeletePartialSkin: "/Admin/SkinsAdmin/DeletePartialSkin",
		EnablePartialSkin: "/Admin/SkinsAdmin/EnablePartialSkin",
		GetCustomCss: "/Admin/SkinsAdmin/GetCustomCss",
		GetCustomJavaScript: "/Admin/SkinsAdmin/GetCustomJavaScript",
		UpdateCustomCss: "/Admin/SkinsAdmin/UpdateCustomCss",
		UpdateCustomJavaScript: "/Admin/SkinsAdmin/UpdateCustomJavaScript"
	},
	ConfigurationAdmin: {
		UploadConfiguration: "/Admin/ConfigurationAdmin/UploadConfiguration",
		LoadConfiguration: "/Admin/ConfigurationAdmin/LoadConfiguration"
	},
	ServerInfoAdmin: {
		Version: "/Admin/ServerInfoAdmin/Version",
		DotnetVersion: "/Admin/ServerInfoAdmin/DotnetVersion",
		GetServerInfo: "/Admin/ServerInfoAdmin/GetServerInfo"
	},
	DeletedElements: {
		DeleteAllMarkedComments:
			"/Admin/DeletedElementsAdmin/DeleteAllMarkedMaterials"
	}
};

