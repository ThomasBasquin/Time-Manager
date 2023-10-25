<script setup lang="ts">
import {
    Card,
    CardContent,
    CardDescription,
    CardFooter,
    CardHeader,
    CardTitle,
} from '@/components/ui/card'
import { Input } from '@/components/ui/input'
import { Button } from '@/components/ui/button'
import { reactive } from 'vue'
import axios from 'axios'


const state = reactive({
    count: 0, email: '', username: '', user: {
        email: '',
        username: '',
        id: 0
    }
})

async function Login() {
    try {
        // Effectuer la requête GET pour récupérer l'utilisateur
        const response = await axios.get('http://localhost:4000/api/users/', {
            params: {
                email: state.email,
                username: state.username
            }
        }

        )
        // Traiter la réponse de l'API
        const user = response.data
        console.log('Utilisateur récupéré :', user)
        for (let i = 0; i < user.data.length; i++) {
            if (user.data[i].email == state.email) {
                state.user = user.data[i]
            }
        }
        if (state.user.email != '') {
            state.count = 2
        }
    } catch (error) {
        console.error('Erreur lors de la récupération de l\'utilisateur :', error)
    }
}

async function goRegister() {
    state.count = 1
}

async function Register() {
    try {
        // Effectuer la requête POST pour créer l'utilisateur
        const response = await axios.post('http://localhost:4000/api/users/', {
            user: {
                email: state.email,
                username: state.username
            }
        })
        // Traiter la réponse de l'API
        const user = response.data
        console.log('Utilisateur créé :', user)
        state.user = user.data
        console.log(state.user)
        state.count = 2
    } catch (error) {
        console.error('Erreur lors de la création de l\'utilisateur :', error)
    }
}

async function deleteUser() {
    try {
        // Effectuer la requête DELETE pour supprimer l'utilisateur
        const response = await axios.delete('http://localhost:4000/api/users/' + state.user.id)
        // Traiter la réponse de l'API
        const user = response.data
        console.log('Utilisateur supprimé :', user)
        state.count = 0
    } catch (error) {
        console.error('Erreur lors de la suppression de l\'utilisateur :', error)
    }

}
</script>

<template>
    <Card v-if="state.count == 0" class="w-1/4 h-2/4">
        <CardHeader>
            <CardTitle>Login to your account</CardTitle>
            <CardDescription>Enter your mail to login to your account.
            </CardDescription>
        </CardHeader>
        <CardContent>
            <Input v-model="state.email" type="email" placeholder="Email" />
        </CardContent>
        <CardFooter class="flex flex-row-reverse">
            <Button @click="Login">Login</Button>
            <Button class="mr-2" @click="goRegister">Create account</Button>
        </CardFooter>
    </Card>
    <Card v-if="state.count == 1" class="w-1/4 h-2/4">
        <CardHeader>
            <CardTitle>Create a account</CardTitle>
            <CardDescription>Enter your mail and a username to create an account</CardDescription>
        </CardHeader>
        <CardContent class="space-y-2">
            <Input v-model="state.username" type="text" placeholder="Username" />
            <Input v-model="state.email" type="email" placeholder="Email" />
        </CardContent>
        <CardFooter class="flex flex-row-reverse">
            <Button class="mr-2" @click="Register">Create account</Button>
        </CardFooter>
    </Card>
    <Card v-if="state.count == 2" class="w-1/4 h-2/4">
        <CardHeader>
            <CardTitle>Logged as {{ state.user.username }}</CardTitle>
            <CardDescription>{{ state.user.email }}</CardDescription>
        </CardHeader>
        <CardContent>
            <CardDescription>Vous êtes connecté !</CardDescription>
        </CardContent>
        <CardFooter class="flex flex-row-reverse">
            <Button class="mr-2" @click="deleteUser">Delete account</Button>
        </CardFooter>
    </Card>
</template>