<template>
  <div style="margin: 50px 20px">
    <div class="alert alert-success" v-if="notice">{{ notice }}</div>
    <div class="alert alert-danger" v-if="error">{{ error }}</div>
  </div>
</template>

<script>
export default {
  name: 'Activation',
  data () {
    return {
      notice: '',
      error: ''
    }
  },
  created () {
    this.$http.plain.patch(`/activation/${this.$route.params.token}`)
      .then(response => this.activationSuccessful(response))
      .catch(error => this.activationFailed(error))
  },
  methods: {
    activationSuccessful (response) {
      this.notice = 'Your account was activated! You can now sign in.'
      this.error = ''
    },
    activationFailed (error) {
      this.error = (error.response && error.response.data && error.response.data.error) || 'Something went wrong'
      this.notice = ''
    }
  }
}
</script>

<style scoped>
</style>
