<template>
  <div style="margin: 50px 20px">
    <b-container class="b-container-styling">
      <h3 style="margin: 20px 20px;">Forgot password</h3>
      <b-form @submit.prevent="submit">
        <div class="alert alert-success" v-if="notice">{{ notice }}</div>
        <div class="alert alert-danger" v-if="error">{{ error }}</div>
        <b-form-row>
          <b-col align-self="center">
            <b-form-group id="email-group" label="Email" label-for="email" style="text-align: start">
              <b-form-input
                id="email"
                v-model="email"
                type="email"
                placeholder="email@example.com"
                style="min-width: 300px"
              ></b-form-input>
            </b-form-group>
          </b-col>

          <b-col align-self="center">
            <b-button style="margin-top: 15px; margin-left: 5px" pill variant="danger" type="submit">Reset</b-button>
          </b-col>
        </b-form-row>
      </b-form>
    </b-container>
  </div>
</template>

<script>
export default {
  name: 'ForgotPassword',
  data () {
    return {
      email: '',
      error: '',
      notice: ''
    }
  },
  methods: {
    submit () {
      this.$http.plain.post('/password_resets', { email: this.email })
        .then(() => this.submitSuccessful())
        .catch(error => this.submitFailed(error))
    },
    submitSuccessful () {
      this.notice = `Email with password reset instructions has been sent to  ${this.email}.`
      this.error = ''
      this.email = ''
    },
    submitFailed (error) {
      this.error = (error.response && error.response.data && error.response.data.error) || ''
    }
  }
}
</script>

<style scoped>
  .b-container-styling {
    width: fit-content;
    height: min-content;
    padding: 10px 40px;
    background-color: white;
    border: darkgrey 3px groove;
    border-radius: 7px;
    font-weight: bold;
  }

  input {
    border: darkgrey 1px solid ;
  }
</style>
