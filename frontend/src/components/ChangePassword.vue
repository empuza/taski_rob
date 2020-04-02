<template>
  <div style="margin-top: 50px">
    <b-container class="b-container-styling">
      <h3 style="margin: 20px 20px">Change password</h3>
      <b-form @submit.prevent="change">
        <div class="alert alert-success" v-if="notice">{{ notice }}</div>
        <div class="alert alert-danger" v-if="error">{{ error }}</div>
        <b-form-row>
          <b-col align-self="center">
            <b-form-group  id="current-password-group" label="Current password" label-for="current_password" style="text-align: start">
              <b-form-input
                id="current_password"
                v-model="current_password"
                type="password"
                required
              ></b-form-input>
            </b-form-group>
          </b-col>
        </b-form-row>
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
            <b-button pill variant="primary" type="submit">Change</b-button>
          </b-col>
        </b-form-row>
      </b-form>
    </b-container>
  </div>
</template>

<script>
export default {
  name: 'ChangePassword',
  data () {
    return {
      current_password: '',
      password: '',
      password_confirmation: '',
      error: '',
      notice: ''
    }
  },
  created () {
    if (!this.$store.state.signedIn) {
      this.$router.replace('/')
    }
  },
  methods: {
    change () {
      this.$http.plain.patch('/change_password', { password: this.password, password_confirmation: this.password_confirmation, user_id: this.$store.state.currentUser.id, current_password: this.current_password })
        .then(response => this.changeSuccessful(response))
        .catch(error => this.changeFailed(error))
    },
    changeSuccessful (response) {
      this.notice = 'Your password has been changed successfully!'
      this.error = ''
      this.current_password = ''
      this.password = ''
      this.password_confirmation = ''
    },
    changeFailed (error) {
      this.error = (error.response && error.response.data && error.response.data.error) || 'Something went wrong'
      this.notice = ''
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
