<script setup lang="ts">
import Login from "@/components/Login.vue";
import Clock from "@/components/Clock.vue";
import WorkingTimes from "@/components/WorkingTimes.vue";
import {
  Tabs,
  TabsContent,
  TabsList,
  TabsTrigger,
} from '@/components/ui/tabs'
</script>

<template>
  <Tabs default-value="login" class="w-screen">
    <TabsList class="grid w-full grid-cols-3">
      <TabsTrigger value="login">
        Account
      </TabsTrigger>
      <TabsTrigger value="clock">
        Clock
      </TabsTrigger>
      <TabsTrigger value="WorkingTimes">
        Working Times
      </TabsTrigger>
    </TabsList>
    <TabsContent value="login" class="justify-center items-center flex flex-col">
      <Login />
    </TabsContent>
    <TabsContent value="clock" class="justify-center items-center flex flex-col">
      <Clock />
    </TabsContent>
    <TabsContent value="WorkingTimes" class="justify-center items-center flex flex-col">
      <WorkingTimes />
    </TabsContent>
  </Tabs>
</template>
