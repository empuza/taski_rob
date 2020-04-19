<template>
  <div style="margin-top: 50px">
    <b-container class="b-container-styling">
      <h3 style="margin: 20px 20px"> Email address - {{ user.email }}</h3>
      <b-form @submit.prevent="update">
        <div class="alert alert-info" v-if="notice">{{ notice }}</div>
        <div class="alert alert-danger" v-if="error">{{ error }}</div>
        <b-form-row>
          <b-col align-self="center">
            <b-form-group  id="role-group" label="Roles" label-for="role" style="text-align: start">
              <b-form-select
                id="role"
                v-model="user.role">
                <b-form-select-option value="admin">Admin</b-form-select-option>
                <b-form-select-option value="manager">Manager</b-form-select-option>
                <b-form-select-option value="user">User</b-form-select-option>
              </b-form-select>
            </b-form-group>
          </b-col>
        </b-form-row>
        <b-form-row>
          <b-col align-self="center">
            <b-button pill variant="primary" type="submit">Change</b-button>
          </b-col>
        </b-form-row>
        <b-form-row>
          <b-col align-self="center" style="margin-top: 10px">
            <router-link to="/admin/users">Users</router-link>
          </b-col>
        </b-form-row>
      </b-form>
    </b-container>
  </div>
</template>

<script>
export default {
  name: 'UserEdit.vue',
  data () {
    return {
      error: '',
      notice: '',
      user: {}
    }
  },
  created () {
    this.checkSignedIn()
  },
  methods: {
    update () {
      this.$http.secured.patch(`/admin/users/${this.$route.params.id}`, { user: { role: this.user.role } })
        .then(response => this.updateSuccessful(response))
        .catch(error => this.updateFailed(error))
    },
    updateSuccessful (response) {
      this.notice = 'User updated'
      this.error = ''
    },
    updateFailed (error) {
      this.error = (error.response && error.response.data && error.response.data.error) || ''
      this.notice = ''
    },
    setError (error, text) {
      this.error = (error.response && error.response.data && error.response.data.error) || text
      this.notice = ''
    },
    checkSignedIn () {
      if (this.$store.state.signedIn && this.$store.getters.isAdmin) {
        this.$http.secured.get(`/admin/users/${this.$route.params.id}`)
          .then(response => {
            if (this.$store.getters.currentUserId === response.data.id) {
              this.$router.replace('/')
              return
            }
            this.user = response.data
          })
          .catch(error => { this.setError(error, 'Something went wrong') })
      } else {
        this.$router.replace('/')
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
