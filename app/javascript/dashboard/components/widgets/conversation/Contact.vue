<template>
  <div class="contact-info">
    <div class="phone-number" v-if="phoneNumber">
      {{ formattedPhoneNumber }}
    </div>
  </div>  
</template>

<script>
export default {
  props: {
    phoneNumber: {
      type: String,
      default: ''
    }
  },

  computed: {
    formattedPhoneNumber() {
      if (!this.phoneNumber) return '';
      
      // Format: +XX-XXX-XXX-XXXX
      return this.phoneNumber.replace(
        /(\+\d{2})(\d{3})(\d{3})(\d{4})/,
        '$1-$2-$3-$4'
      );
    }
  }
}
</script>
