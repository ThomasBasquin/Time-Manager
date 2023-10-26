<script setup lang="ts">
import Login from "@/components/Login.vue";
import Clock from "@/components/Clock.vue";
import {
  Tabs,
  TabsContent,
  TabsList,
  TabsTrigger,
} from '@/components/ui/tabs'
</script>

<template>
  <Tabs default-value="login" class="w-screen">
    <TabsList class="grid w-full grid-cols-2">
      <TabsTrigger value="login">
        Account
      </TabsTrigger>
      <TabsTrigger value="clock">
        Clock
      </TabsTrigger>
    </TabsList>
    <TabsContent value="login" class="justify-center items-center flex flex-col">
      <Login />
    </TabsContent>
    <TabsContent value="clock" class="justify-center items-center flex flex-col">
      <Clock />
    </TabsContent>
  </Tabs>
</template>
