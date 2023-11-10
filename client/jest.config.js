module.exports = {
  testEnvironment: "jsdom",
  moduleFileExtensions: [
    "js",
    "json",
    // indiquez à Jest de traiter les fichiers `*.vue`
    "vue",
  ],
  transform: {
    // traitez les fichiers `*.vue` avec `vue-jest`
    ".*\\.(vue)$": "vue-jest",
    // traitez les fichiers `*.js` avec `babel-jest`
    ".*\\.(js)$": "babel-jest",
  },
  moduleNameMapper: {
    // mapper les imports de styles pour qu'ils ne causent pas d'erreurs lors des tests
    "\\.(css|less|scss|sass)$": "<rootDir>/__mocks__/styleMock.js",
  },
};
