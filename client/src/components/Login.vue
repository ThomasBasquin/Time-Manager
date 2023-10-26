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
import axios from 'axios'
import { store } from '@/store.ts'


if (localStorage.getItem('user') != null) {
    store.user = JSON.parse(localStorage.getItem('user') || '{}')
    store.count = 2
}

async function Login() {
    try {
        // Effectuer la requête GET pour récupérer l'utilisateur
        const response = await axios.get('http://localhost:4000/api/users/', {
            params: {
                email: store.email
            }
        }

        )
        // Traiter la réponse de l'API
        const user = response.data
        console.log('Utilisateur récupéré :', user)
        for (let i = 0; i < user.data.length; i++) {
            if (user.data[i].email == store.email) {
                store.user = user.data[i]
            }
        }
        if (store.user.email != '') {
            localStorage.setItem('user', JSON.stringify(store.user))
            store.count = 2
            store.email = ''
            store.username = ''
        }
    } catch (error) {
        console.error('Erreur lors de la récupération de l\'utilisateur :', error)
    }
}

async function goRegister() {
    store.count = 1
}

async function Register() {
    try {
        // Effectuer la requête POST pour créer l'utilisateur
        const response = await axios.post('http://localhost:4000/api/users/', {
            user: {
                email: store.email,
                username: store.username
            }
        })
        // Traiter la réponse de l'API
        const user = response.data
        console.log('Utilisateur créé :', user)
        store.user = user.data
        console.log(store.user)
        store.count = 2
        store.email = ''
        store.username = ''
    } catch (error) {
        console.error('Erreur lors de la création de l\'utilisateur :', error)
    }
}

async function deleteUser() {
    try {
        // Effectuer la requête DELETE pour supprimer l'utilisateur
        const response = await axios.delete('http://localhost:4000/api/users/' + store.user.id)
        // Traiter la réponse de l'API
        const user = response.data
        console.log('Utilisateur supprimé :', user)
        store.count = 0
        store.user = {
            email: '',
            username: '',
            id: 0
        }
        store.email = ''
        store.username = ''
        localStorage.removeItem('user')
    } catch (error) {
        console.error('Erreur lors de la suppression de l\'utilisateur :', error)
    }
}

async function logoutUser() {
    store.count = 0
    store.user = {
        email: '',
        username: '',
        id: 0
    }
    store.email = ''
    store.username = ''
    localStorage.removeItem('user')
}

async function editUser() {
    try {
        // Effectuer la requête PUT pour modifier l'utilisateur
        const response = await axios.put('http://localhost:4000/api/users/' + store.user.id, {
            user: {
                email: store.email,
                username: store.username
            }
        })
        // Traiter la réponse de l'API
        const user = response.data
        console.log('Utilisateur modifié :', user)
        store.user = user.data
        store.count = 2
        store.email = ''
        store.username = ''
    } catch (error) {
        console.error('Erreur lors de la modification de l\'utilisateur :', error)
    }
}
</script>

<template>
    <Card v-if="store.count == 0" class="w-1/4 h-2/4">
        <CardHeader>
            <CardTitle>Login to your account</CardTitle>
            <CardDescription>Enter your mail to login to your account.
            </CardDescription>
        </CardHeader>
        <CardContent>
            <Input v-model="store.email" type="email" placeholder="Email" />
        </CardContent>
        <CardFooter class="flex flex-row-reverse">
            <Button @click="Login">Login</Button>
            <Button class="mr-2" @click="goRegister">Create account</Button>
        </CardFooter>
    </Card>
    <Card v-if="store.count == 1" class="w-1/4 h-2/4">
        <CardHeader>
            <CardTitle>Create a account</CardTitle>
            <CardDescription>Enter your mail and a username to create an account</CardDescription>
        </CardHeader>
        <CardContent class="space-y-2">
            <Input v-model="store.username" type="text" placeholder="Username" />
            <Input v-model="store.email" type="email" placeholder="Email" />
        </CardContent>
        <CardFooter class="flex flex-row-reverse">
            <Button class="mr-2" @click="Register">Create account</Button>
        </CardFooter>
    </Card>
    <Card v-if="store.count == 2" class="w-1/4 h-2/4">
        <CardHeader>
            <CardTitle>Logged as {{ store.user.username }}</CardTitle>
            <CardDescription>{{ store.user.email }}</CardDescription>
            <Button @click="store.count = 3">Edit Profile</Button>
        </CardHeader>
        <CardContent>
            <CardDescription>Vous êtes connecté !</CardDescription>
        </CardContent>
        <CardFooter class="flex flex-row-reverse">
            <Button @click="logoutUser">Logout</Button>
            <Button class="mr-2" @click="deleteUser">Delete account</Button>
        </CardFooter>
    </Card>
    <Card v-if="store.count == 3" class="w-2/4 h-2/4">
        <CardHeader>
            <CardTitle>Logged as {{ store.user.username }}</CardTitle>
            <CardDescription>{{ store.user.email }}</CardDescription>
        </CardHeader>
        <CardContent class="space-y-2">
            <Input v-model="store.username" type="text" :placeholder="store.user.username" />
            <Input v-model="store.email" type="email" :placeholder="store.user.email" />
        </CardContent>
        <CardFooter class="flex flex-row-reverse">
            <Button @click="editUser">Change information</Button>
        </CardFooter>
    </Card>
</template>