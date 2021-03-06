import Vue from "vue";

export const passwordRules = [
	value =>
		!!value || Vue.prototype.i18n.t("Global.validation.password.required"),
	value =>
		value.length >= config.PasswordValidation.RequiredLength ||
		Vue.prototype.i18n.t("Global.validation.password.requiredLength", {
			requiredLength: config.PasswordValidation.RequiredLength
		}),
	value =>
		[...new Set(value.split(""))].length >=
			config.PasswordValidation.RequiredUniqueChars ||
		Vue.prototype.i18n.t("Global.validation.password.requiredUniqueChars", {
			requiredUniqueChars: config.PasswordValidation.RequiredUniqueChars
		}),
	value =>
		/\d/.test(value) ||
		Vue.prototype.i18n.t("Global.validation.password.requireDigit"),
	value =>
		/[a-z]/.test(value) ||
		Vue.prototype.i18n.t("Global.validation.password.requireLowercase"),
	value =>
		/[A-Z]/.test(value) ||
		Vue.prototype.i18n.t("Global.validation.password.requireUppercase"),
	value =>
		/[^a-zA-Z0-9]/.test(value) ||
		Vue.prototype.i18n.t("Global.validation.password.requireNonAlphanumeric")
];

export const userNameRules = [
	value =>
		!!value || Vue.prototype.i18n.t("Global.validation.userName.required"),
	value =>
		value.length >= 3 ||
		Vue.prototype.i18n.t("Global.validation.userName.minLength", {
			minLength: 3
		}),
	value =>
		value.length <= config.DbColumnSizes.Users_UserName ||
		Vue.prototype.i18n.t("Global.validation.userName.maxLength", {
			maxLength: config.DbColumnSizes.Users_UserName
		}),
	value =>
		new RegExp("^[" + config.Register.AllowedUserNameCharacters + "]+$").test(
			value
		) ||
		Vue.prototype.i18n.t("Global.validation.userName.allowedUserNameCharacters", {
			allowedUserNameCharacters: config.Register.AllowedUserNameCharacters
		}),
	value =>
		!this.userNameInDb ||
		Vue.prototype.i18n.t("Global.validation.userName.nameInDb")
];

export const emailRules = [
	value => !!value || Vue.prototype.i18n.t("Global.validation.email.required"),
	value =>
		/.+@.+/.test(value) ||
		Vue.prototype.i18n.t("Global.validation.email.emailSig"),
	value =>
		value.length <= config.DbColumnSizes.Users_Email ||
		Vue.prototype.i18n.t("Global.validation.email.maxLength", {
			maxLength: config.DbColumnSizes.Users_Email
		})
];
