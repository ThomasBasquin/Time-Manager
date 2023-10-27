<script setup lang="ts">
import { reactive } from 'vue'
import { store } from '@/store.ts'
import {
    Card,
    CardContent,
    CardDescription,
    CardFooter,
    CardHeader,
    CardTitle,
} from '@/components/ui/card'
import { Button } from '@/components/ui/button'
import axios from 'axios'
import CardList from './CardList.vue'
import { ref } from 'vue'

const state = reactive({ count: 0 })

function changeState() {
    if(state.count == 0)
        state.count = 1;
    else
        state.count = 0;
}

let workingtimes = ref([]);
let isLoaded = ref(false)

async function getWorkingTimes() {
    try {
        // Effectuer la requête GET pour récupérer l'utilisateur
        const request = "http://localhost:4000/api/workingtimes/" + store.user.id
        const response = await axios.get(request, {})

        // Traiter la réponse de l'API
        workingtimes = response.data
        isLoaded.value = true
        console.log('working time récupéré :', workingtimes)
    } catch (error) {
        
        console.error('Erreur lors de la récupération de l\'utilisateur :', error)
    }
}

console.log(store.user.id)
getWorkingTimes()

</script>

<template>
    <Card class="flex w-11/12">
        <Card class="w-1/4">
            <CardHeader class="">
                <CardTitle>Clock In/Out</CardTitle>
                <CardDescription></CardDescription>
            </CardHeader>
            <CardContent class="">
                <Button v-if="state.count == 0" class="w-32" @click="changeState">Clock In</Button>
                <Button v-if="state.count == 1" class="w-32" @click="changeState">Clock Out</Button>
            </CardContent>
            <CardFooter>
            </CardFooter>
        </Card>
        <Card v-if="isLoaded === true" class="w-3/4">
            <ul id="demo">
                <li v-for="wtime in workingtimes" class="item-{{$index}}">
                    {{$index}} - {{wtime.user.id}} - {{wtime.end}} - {{wtime.start}}
                </li>
            </ul>
        </Card>
    </Card>
</template>