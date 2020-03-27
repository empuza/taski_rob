<template>
  <header class="header">
    <div>
      <div>
        <b-navbar class="navbar-links" toggleable="md" type="dark" variant="dark">
          <b-navbar-brand href="/tasks">
            <img src="../assets/taskirób-logo.png" alt="TaskiRób">
          </b-navbar-brand>
          <b-navbar-nav class="ml-auto">
            <b-nav-item right><router-link to="/tasks" v-if="signedIn()">Tasks</router-link></b-nav-item>
            <b-nav-item right><router-link to="/" v-if="!signedIn()">Sign In</router-link></b-nav-item>
            <b-nav-item right><router-link to="/signup" v-if="!signedIn()">Sign Up</router-link></b-nav-item>
            <b-nav-item right><a href="#" @click.prevent="signedOut" v-if="signedIn()">Sign out</a></b-nav-item>
          </b-navbar-nav>
        </b-navbar>
      </div>
    </div>
  </header>
</template>

<script>
export default {
  name: 'Header',
  methods: {
    setError (error, text) {
      this.error = (error.response && error.response.data && error.response.data.error) || text
    },
    signedIn () {
      return localStorage.signedIn
    },
    signedOut () {
      this.$http.secured.delete('/signin')
        .then(response => {
          delete localStorage.csrf
          delete localStorage.signedIn
          this.$router.replace('/')
        })
        .catch(error => this.setError(error, 'Cannot sign out'))
    }
  }
}
</script>

<style scoped>
  a {
    color: white;
  }

  .navbar-links {
    font-weight: bold;
    font-size: large;
  }
</style>
