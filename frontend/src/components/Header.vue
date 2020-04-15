<template>
  <header class="header">
    <div>
      <div>
        <b-navbar class="navbar-links" toggleable="md" type="dark" variant="dark">
          <b-navbar-brand href="/tasks">
            <img src="../assets/taskirób-logo.png" alt="TaskiRób">
          </b-navbar-brand>
          <b-navbar-nav class="ml-auto">
            <b-nav-text right><div v-if="signedIn()">Welcome {{ this.$store.state.currentUser.username }}</div></b-nav-text>
            <b-nav-item right><router-link to="/tasks" v-if="signedIn()">Tasks</router-link></b-nav-item>
            <b-nav-item-dropdown
              id="settings-dropdown"
              text="Settings"
              class="dropdown"
              toggle-text="dropdown"
              right
            >
              <b-nav-item right><router-link to="/user_details" v-if="signedIn()" class="navigation-links">User details</router-link></b-nav-item>
              <b-nav-item right><router-link to="/change_password" v-if="signedIn()" class="navigation-links">Change password</router-link></b-nav-item>
            </b-nav-item-dropdown>
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
      return this.$store.state.signedIn
    },
    signedOut () {
      this.$store.commit('unsetCurrentUser')
      this.$http.secured.delete('/signin')
        .then(response => {
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

  .navigation-links {
    color: #2c3e50;
  }

</style>
