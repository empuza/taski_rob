<template>
  <div style="margin-top: 50px">
    <b-container class="b-container-styling">
      <h3 style="margin: 20px 20px">Sign In</h3>
      <b-form @submit.prevent="signin">
        <div class="alert alert-danger" v-if="error">{{ error }}</div>
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
            <b-button pill variant="primary" type="submit">Sign In</b-button>
          </b-col>
        </b-form-row>
      </b-form>
    </b-container>
  </div>
</template>

<script>
export default {
  name: 'Signin',
  data () {
    return {
      email: '',
      password: '',
      error: ''
    }
  },
  created () {
    this.checkSignedIn()
  },
  updated () {
    this.checkSignedIn()
  },
  methods: {
    signin () {
      this.$http.plain.post('/signin', {email: this.email, password: this.password})
        .then(response => this.signinSuccessful(response))
        .catch(error => this.signinFailed(error))
    },
    signinSuccessful (response) {
      if (!response.data.csrf) {
        this.signinFailed(response)
        return
      }
      localStorage.csrf = response.data.csrf
      localStorage.signedIn = true
      this.error = ''
      this.$router.replace('/tasks')
    },
    signinFailed (error) {
      this.error = (error.response && error.response.data && error.response.data.error) || ''
      delete localStorage.csrf
      delete localStorage.signedIn
    },
    checkSignedIn () {
      if (localStorage.signedIn) {
        this.$router.replace('/tasks')
      }
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
