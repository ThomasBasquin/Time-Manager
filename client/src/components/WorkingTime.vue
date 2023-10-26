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

const state = reactive({ count: 0 })

function changeState() {
    if(state.count == 0)
        state.count = 1;
    else
        state.count = 0;
}

</script>

<template>
    <Card class="flex">
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
        <Card v-if="store.user.id != 0" class="w-3/4">
            <CardHeader class="">
                <CardTitle>Clock In/Out</CardTitle>
                <CardDescription>Enter your hours</CardDescription>
            </CardHeader>
        </Card>
    </Card>
</template>