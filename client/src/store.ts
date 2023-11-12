// store.js
import { reactive } from "vue";

export const store = reactive({
  count: 0,
  email: "",
  username: "",
  password: "",
  isLogged: false,
  user: {
    email: "",
    username: "",
    id: 0,
    role: "none",
  },
  working: false,
  clock: {},
  workingtimes: [],
});
