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

const state = reactive({ count: 0 })

function increment() {
    state.count++
    console.log(state.count)
}
</script>

<template>
    <Card v-if="state.count == 0" class="w-1/4 h-2/4">
        <CardHeader>
            <CardTitle>Login to your user</CardTitle>
            <CardDescription>Enter your mail to login to your account</CardDescription>
        </CardHeader>
        <CardContent>
            <Input type="email" placeholder="Email" />
        </CardContent>
        <CardFooter class="flex flex-row-reverse">
            <Button>Login</Button>
            <Button class="mr-2" @click="increment">Create account</Button>
        </CardFooter>
    </Card>
    <Card v-if="state.count == 1" class="w-1/4 h-2/4">
        <CardHeader>
            <CardTitle>Create a account</CardTitle>
            <CardDescription>Enter your mail to create an account</CardDescription>
        </CardHeader>
        <CardContent class="space-y-2">
            <Input type="text" placeholder="Username" />
            <Input type="email" placeholder="Email" />
        </CardContent>
        <CardFooter class="flex flex-row-reverse">
            <Button class="mr-2" @click="state.count = 0">Create account</Button>
        </CardFooter>
    </Card>
</template>