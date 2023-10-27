// store.js
import { reactive } from 'vue'

export const store = reactive({
    count: 0, email: '', username: '', isLogged: false, user: {
        email: '',
        username: '',
        id: 0
    }
})