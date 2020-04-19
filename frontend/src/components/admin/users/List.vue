<template>
  <div style="margin: 50px 40px">
    <div class="alert alert-danger" v-if="error">{{ error }}</div>
    <h3>Users</h3>
    <br />
    <table class="table">
      <thead>
        <tr>
          <th>ID</th>
          <th>Email</th>
          <th>Role</th>
          <th v-if="showTasksLink()">Tasks</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="user in users" :key="user.id" :user="user">
          <td>
            {{ user.id }}
          </td>
          <td td v-if="showUsersLink(user)">
            <router-link :to="{ path: '/admin/users/' + user.id }">
              {{ user.email }}
            </router-link>
          </td>
          <td td v-else>
            {{ user.email }}
          </td>
          <td>
            {{ user.role }}
          </td>
          <td v-if="showTasksLink()">
            <router-link :to="{ path: '/admin/users/' + user.id + '/tasks' }">
              <b-icon variant="default" size="md" icon="list-check"></b-icon>
            </router-link>
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script>
export default {
  name: 'UsersList',
  data () {
    return {
      error: '',
      users: []
    }
  },
  created () {
    if (this.$store.state.signedIn && (this.$store.getters.isAdmin || this.$store.getters.isManager)) {
      this.$http.secured.get('/admin/users')
        .then(response => { this.users = response.data })
        .catch(error => { this.setError(error, 'Something went wrong') })
    } else {
      this.$router.replace('/')
    }
  },
  methods: {
    setError (error, text) {
      this.error = (error.response && error.response.data && error.response.data.error) || text
    },
    showUsersLink (user) {
      return this.$store.getters.isAdmin && this.$store.getters.currentUserId !== user.id
    },
    showTasksLink () {
      return this.$store.getters.isAdmin
    }
  }
}
</script>

<style lang="css">
  a i {
    cursor: pointer;
    color: #212529;
  }
</style>
