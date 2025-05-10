<template>
  <div class="contact-details">
    <p v-if="contact.phone_number" class="text-sm">
      {{ contact.masked_phone_number || contact.phone_number }}
    </p>