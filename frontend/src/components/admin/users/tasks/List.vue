<template>
  <div style="margin: 50px 40px">
    <div class="alert alert-danger" v-if="error">{{ error }}</div>
    <h3>User Tasks</h3>
    <br />
    <table class="table">
      <thead>
      <tr>
        <th>ID</th>
        <th>User ID</th>
        <th>Name</th>
        <th>Deadline</th>
      </tr>
      </thead>
      <tbody>
      <tr v-for="task in tasks" :key="task.id" :task="task">
        <th>{{ task.id }}</th>
        <th>{{ task.user_id }}</th>
        <td>{{ task.name }}</td>
        <td>{{ task.deadline }}</td>
      </tr>
      </tbody>
    </table>
  </div>
</template>

<script>
export default {
  name: 'UserTasksList',
  data () {
    return {
      error: '',
      tasks: []
    }
  },
  created () {
    if (this.$store.state.signedIn && this.$store.getters.isAdmin) {
      this.$http.secured.get(`/admin/users/${this.$route.params.id}/tasks`)
        .then(response => { this.tasks = response.data })
        .catch(error => { this.setError(error, 'Something went wrong') })
    } else {
      this.$router.replace('/')
    }
  },
  methods: {
    setError (error, text) {
      this.error = (error.response && error.response.data && error.response.data.error) || text
    }
  }
}
</script>
