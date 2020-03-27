<template>
  <div style="margin-top: 50px">
    <b-container class="b-container-styling">
      <h3 style="margin: 20px 20px">Reset password</h3>
      <b-form @submit.prevent="reset">
        <div class="alert alert-success" v-if="notice">{{ notice }}</div>
        <div class="alert alert-danger" v-if="error">{{ error }}</div>
        <b-form-row>
          <b-col align-self="center">
            <b-form-group  id="password-group" label="Password" label-for="password" style="text-align: start">
              <b-form-input
                id="password"
                v-model="password"
                type="password"
                required
              ></b-form-input>
            </b-form-group>
          </b-col>
        </b-form-row>

        <b-form-row>
          <b-col align-self="center">
            <b-form-group  id="password-confirmation-group" label="Password confirmation" label-for="password-confirmation" style="text-align: start">
              <b-form-input
                id="password-confirmation"
                v-model="password_confirmation"
                type="password"
                required
              ></b-form-input>
            </b-form-group>
          </b-col>
        </b-form-row>

        <b-form-row>
          <b-col align-self="center">
            <b-button pill variant="primary" type="submit">Reset</b-button>
          </b-col>
        </b-form-row>
      </b-form>
    </b-container>
  </div>
</template>

<script>
export default {
  name: 'ResetPassword',
  data () {
    return {
      password: '',
      password_confirmation: '',
      error: '',
      notice: ''
    }
  },
  created () {
    this.checkPasswordToken()
  },
  methods: {
    reset () {
      this.$http.plain.patch(`/password_resets/${this.$route.params.token}`, { password: this.password, password_confirmation: this.password_confirmation })
        .then(response => this.resetSuccessful(response))
        .catch(error => this.resetFailed(error))
    },
    resetSuccessful (response) {
      this.notice = 'Your password has been reset successfully! Please sign in with your new password.'
      this.error = ''
      this.password = ''
      this.password_confirmation = ''
    },
    resetFailed (error) {
      this.error = (error.response && error.response.data && error.response.data.error) || 'Something went wrong'
      this.notice = ''
    },
    checkPasswordToken () {
      this.$http.plain.get(`/password_resets/${this.$route.params.token}`)
        .catch(error => {
          this.resetFailed(error)
          this.$router.replace('/')
        })
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
