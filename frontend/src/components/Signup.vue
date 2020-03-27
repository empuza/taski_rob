<template>
  <div style="margin-top: 50px">
    <b-container class="b-container-styling">
      <h3 style="margin: 20px 20px">Sign Up</h3>
      <b-form @submit.prevent="signup">
        <div class="alert alert-success" v-if="notice">{{ notice }}</div>
        <div class="alert alert-danger" v-if="error">{{ error }}</div>
        <b-form-row>
          <b-col align-self="center">
            <b-form-group id="username-group" label="Username" label-for="username" style="text-align: start">
              <b-form-input
                id="username"
                v-model="username"
                required
                placeholder="Jane"
              ></b-form-input>
            </b-form-group>
          </b-col>
        </b-form-row>

        <b-form-row>
          <b-col align-self="center">
            <b-form-group id="email-group" label="Email" label-for="email" style="text-align: start">
              <b-form-input
                id="email"
                v-model="email"
                type="email"
                required
                placeholder="sample@gmail.com"
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
            <b-button pill variant="primary" type="submit">Sign Up</b-button>
          </b-col>
        </b-form-row>

        <b-form-row style="margin: 10px 10px">
          <b-col align-self="center">
            <b-link to="/">Sign In</b-link>
          </b-col>
        </b-form-row>
      </b-form>
    </b-container>
  </div>
</template>

<script>
export default {
  name: 'Signup',
  data () {
    return {
      username: '',
      email: '',
      password: '',
      password_confirmation: '',
      error: '',
      notice: ''
    }
  },
  methods: {
    signup () {
      this.$http.plain.post('/signup', {
        username: this.username,
        email: this.email,
        password: this.password,
        password_confirmation: this.password_confirmation
      })
        .then(response => this.signupSuccessful(response))
        .catch(error => this.signupFailed(error))
    },
    signupSuccessful (response) {
      if (!response.data.csrf) {
        this.signupFailed(response)
        return
      }
      localStorage.csrf = response.data.csrf
      localStorage.signedIn = true
      this.error = ''
      this.notice = 'Activation link was sent to your email. Check your inbox.'
      this.$router.replace('/tasks')
    },
    signupFailed (error) {
      this.error = (error.response && error.response.data && error.response.data.error) || 'Something went wrong'
      delete localStorage.csrf
      delete localStorage.signedIn
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
