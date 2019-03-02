// This is just an example,
// so you can safely delete all default props below

export default {
  loginOrRegisterMenu: {
    enter: "Войти",
    register: "Зарегистрироваться"
  },
  app: {
    loading: "Загрузка...",
    canNotConnectApi: "Невозможно соединиться с API."
  },
  captcha: {
    newMessageBtn: "Выдать новое изображение",
    waitMessage: "Что бы сгенерировать новый токен, нужно немного подождать, попробуйте через некоторое время",
    enterToken: "Введите текст с картинки",
    required: "@:captcha.enterToken",
  },
  userMenu: {
    profile: "Профиль",
    yourAccount: "Личный кабинет",
    adminPanel: "Админка",
    exit: "Выйти",
    logoutNotifyMessage: "Вы вышли",
  },
  login: {
    nameOrEmail: "Имя или email",
    password: "Пароль",
    entering: "Заходим...",
    enterBtn: "Войти",
    forgotPassword: "Забыли пароль?",
    notMyComputer: "Чужой компьютер",
    enterSuccess: "Вы зашли",
    validation: {
      nameOrEmail: {
        required: "Введите имя или email"
      },
      password: {
        required: "Введите пароль"
      },
    }
  },
  register: {
    title: "Зарегистрироваться",
    userName: "Имя пользователя",
    email: "Email",
    password: "Пароль",
    password2: "Подтвердите пароль",
    registerBtn: "@:register.title",
    registering: "Регистрируемся...",
    emailSent: "Сообщение с ссылкой для регистрации отправлено на email",
    validation: {
      userName: {
        required: "Введите имя пользователя",
        minLength: "Имя пользователя должно быть не менее чем из 3 букв",
        maxLength: `Имя пользователя должно состоять не более чем из ${config.DbColumnSizes.Users_UserName} символов`
      },
      email: {
        required: "Введите email",
        emailSig: "Неправильная сигнатура email",
        maxLength: `Email должен состоять не более чем из ${config.DbColumnSizes.Users_Email} символов`
      },
      password: {
        required: "Введите пароль",
        minLength: `Пароль должен состоять не менее чем из ${config.PasswordValidation.MinLength} символов`,
        minDifferentChars: `В пароле должно быть не менее ${config.PasswordValidation.MinDifferentChars} разных символов`
      },
      password2: {
        equals: "Пароли должны совпадать"
      }
    }
  }
}