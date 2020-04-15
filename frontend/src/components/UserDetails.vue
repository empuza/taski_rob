<template>
  <div style="margin-top: 50px">
    <b-container class="b-container-styling">
      <h3 style="margin: 20px 20px">Update details</h3>
      <b-form @submit.prevent="update">
        <div class="alert alert-success" v-if="notice">{{ notice }}</div>
        <div class="alert alert-danger" v-if="error">{{ error }}</div>
        <b-form-row>
          <b-col align-self="center">
            <b-form-group  id="username-group" label="Username" label-for="username" style="text-align: start">
              <b-form-input
                id="username"
                v-model="username"
                type="text"
              ></b-form-input>
            </b-form-group>
          </b-col>
        </b-form-row>
        <b-form-row>
          <b-col align-self="center">
            <b-form-group  id="email-group" label="Email" label-for="email" style="text-align: start">
              <b-form-input
                id="email"
                v-model="email"
                type="email"
              ></b-form-input>
            </b-form-group>
          </b-col>
        </b-form-row>
        <b-form-row>
          <b-col align-self="center">
            <b-button pill variant="primary" type="submit">Update</b-button>
          </b-col>
        </b-form-row>
      </b-form>
    </b-container>
  </div>
</template>

<script>
export default {
  name: 'UserDetails',
  data () {
    return {
      id: '',
      username: '',
      email: '',
      error: '',
      notice: ''
    }
  },
  created () {
    if (!this.$store.state.signedIn) {
      this.$router.replace('/')
    } else {
      this.id = this.$store.state.currentUser.id
      this.username = this.$store.state.currentUser.username
      this.email = this.$store.state.currentUser.email
  }
  },
  methods: {
    update () {
      this.$http.secured.patch(`/users/${this.id}`, { username: this.username, email: this.email })
        .then(response => this.updateSuccessful(response))
        .catch(error => this.updateFailed(error))
    },
    updateSuccessful (response) {
      this.notice = 'Your details have been updated successfully!'
      this.error = ''
      this.$store.state.currentUser.username = this.username
      this.$store.state.currentUser.email = this.email
    },
    updateFailed (error) {
      this.error = (error.response && error.response.data && error.response.data.error) || 'Something went wrong'
      this.notice = ''
      this.username = this.$store.state.currentUser.username
      this.email = this.$store.state.currentUser.email
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
