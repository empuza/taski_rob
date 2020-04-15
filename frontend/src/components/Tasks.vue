<template>
  <div style="margin: 50px 20px">
    <h1 style="margin: 20px 20px;">Tasks</h1>
    <b-container class="b-container-styling">
      <h3 style="margin: 20px 20px;">Add task</h3>
      <b-form @submit.prevent="addTask">
        <div class="alert alert-danger" v-if="error">{{ error }}</div>
        <b-form-row>
          <b-col align-self="center">
            <b-form-group id="new_task_name_group" label="Name" label-for="new_task_name" style="text-align: start">
              <b-form-input
                style="min-width: 300px"
                id="new_task_name"
                v-model="new_task.name"
                required
                placeholder="Fix the bug in the code"
              ></b-form-input>
            </b-form-group>
          </b-col>

          <b-col align-self="center">
            <b-form-group id="new_task_deadline_group" label="Deadline" label-for="new_task_deadline" style="text-align: start">
              <b-form-input
                style="width: fit-content"
                id="new_task_deadline"
                v-model="new_task.deadline"
                type="date"
                required
              ></b-form-input>
            </b-form-group>
          </b-col>

          <b-col align-self="center">
            <b-button style="margin-top: 15px; margin-left: 5px" pill variant="success" type="submit">Add</b-button>
          </b-col>
        </b-form-row>
      </b-form>
    </b-container>
    <b-container>
      <b-row>
        <b-col>
          <h4 class="header">Tasks</h4>
          <b-list-group>
            <b-list-group-item v-for="task in tasks" :key="task.id" :task="task">
              <b-row>
                <b-col cols="1" align-self="center">
                  <b-form inline>
                    <b-form-checkbox
                      size="lg"
                      :key="'checkbox-'+ task.id"
                      :id="'checkbox-'+ task.id"
                      v-model="task.done"
                      :name="'checkbox-'+ task.id"
                      :checked="task.done"
                      @change="updateTask(task)"
                    ></b-form-checkbox>
                  </b-form>
                </b-col>
                <b-col cols="10">
                  <div v-show="task != editedTask" @dblclick="editTask(task)">
                    <p> {{ task.name }} </p>
                  </div>
                  <div v-show="task == editedTask">
                    <b-form-input
                      style="min-width: 150px"
                      v-model="task.name"
                      v-task-focus
                      @blur="updateTask(task)"
                      @keyup.enter="updateTask(task)"
                    ></b-form-input>
                  </div>
                  <span style="font-weight: bold; margin: 0px 40px"> Deadline: {{ moment(task.deadline).format('DD-MM-YYYY') }} </span>
                </b-col>
                <b-col cols="1" align-self="center">
                  <b-button class="delete-button" @click.prevent="deleteTask(task)">
                    <p class="h5 mb-2"><b-icon variant="danger" size="md" icon="x-circle-fill"></b-icon></p>
                  </b-button>
                </b-col>
              </b-row>
            </b-list-group-item>
          </b-list-group>
        </b-col>

        <b-col>
          <h4 class="header">Done Tasks</h4>
          <b-list-group>
            <b-list-group-item style="background-color: lightgreen" class="task-item" v-for="task in doneTasks" :key="task.id" :task="task">
              <b-row>
                <b-col cols="1" align-self="center">
                  <b-form inline>
                    <b-form-checkbox
                      @change="updateTask(task)"
                      type="checkbox"
                      size="lg"
                      :id="'checkbox-'+ task.id"
                      :key="'checkbox-'+ task.id"
                      v-model="task.done"
                      :name="'checkbox-'+ task.id"
                      :checked="task.done"
                    ></b-form-checkbox>
                  </b-form>
                </b-col>
                <b-col cols="10">
                  <div v-show="task != editedTask" @dblclick="editTask(task)">
                    <p> {{ task.name }} </p>
                  </div>
                  <div v-show="task == editedTask">
                    <b-form-input
                      style="min-width: 150px"
                      v-model="task.name"
                      v-task-focus
                      @blur="updateTask(task)"
                      @keyup.enter="updateTask(task)"
                    ></b-form-input>
                  </div>
                  <span style="font-weight: bold; margin: 0px 40px"> Deadline: {{ moment(task.deadline).format('DD-MM-YYYY') }} </span>
                </b-col>
                <b-col cols="1" align-self="center">
                  <b-button class="delete-button-done" @click.prevent="deleteTask(task)">
                    <p class="h5 mb-2"><b-icon variant="danger" size="md" icon="x-circle-fill"></b-icon></p>
                  </b-button>
                </b-col>
              </b-row>
            </b-list-group-item>
          </b-list-group>
        </b-col>
      </b-row>
    </b-container>
  </div>
</template>
<script>
export default {
  name: 'Tasks',
  data () {
    return {
      new_task: {
        name: '',
        deadline: ''
      },
      error: '',
      tasks: [],
      doneTasks: [],
      editedTask: '',
      nameBeforeUpdate: ''
    }
  },
  created () {
    if (!localStorage.signedIn) {
      this.$router.replace('/')
    } else {
      this.$http.secured.get('api/tasks')
        .then(response => {
          this.tasks = response.data.tasks
          this.doneTasks = response.data.doneTasks
        })
        .catch(error => this.setError(error, 'Something went wrong'))
    }
  },
  methods: {
    setError (error, text) {
      this.error = (error.response && error.response.data && error.response.data.error) || text
    },
    addTask () {
      const value = this.new_task
      if (value.name && value.deadline) {
        this.$http.secured.post('/api/tasks', { task: value })
          .then(response => {
            this.tasks.push(response.data)
            this.new_task.name = ''
            this.new_task.deadline = ''
          })
          .catch(error => this.setError(error, 'Cannot create new task'))
      }
    },
    editTask (task) {
      this.editedTask = task
      this.nameBeforeUpdate = task.name
    },
    updateTask (task) {
      // eslint-disable-next-line no-console
      console.log(task)
      this.$http.secured.patch(`/api/tasks/${task.id}`, {task: task})
        .then(response => {
          if (this.tasks.includes(task) && task.done === true) {
            // eslint-disable-next-line no-console
            console.log('W taskach')
            this.tasks.splice(this.tasks.indexOf(task), 1)
            this.doneTasks.push(task)
          } else if(this.doneTasks.includes(task) && task.done === false) {
            // eslint-disable-next-line no-console
            console.log('W zrobionych taskach')
            this.doneTasks.splice(this.doneTasks.indexOf(task), 1)
            this.tasks.push(task)
          }
          this.editedTask = ''
          this.error = ''
        })
        .catch(error => {
          if (task.name === '') {
            task.name = this.nameBeforeUpdate
            // eslint-disable-next-line no-console
            console.log(this.editedTask.name)
            task.name = this.editedTask.name
          }
          this.setError(error, 'Cannot update this task')
        })
    },
    deleteTask (task) {
      this.$http.secured.delete(`/api/tasks/${task.id}`)
        .then(response => {
          if (this.tasks.includes(task)) {
            // eslint-disable-next-line no-console
            console.log('W taskach')
            this.tasks.splice(this.tasks.indexOf(task), 1)
          } else {
            // eslint-disable-next-line no-console
            console.log('W zrobionych taskach')
            this.doneTasks.splice(this.doneTasks.indexOf(task), 1)
          }
        })
        .catch(error => this.setError(error, 'Cannot delete this task'))
    }
  },
  directives: {
    'task-focus': function (el) {
      el.focus()
    }
  }
}
</script>

<style scoped>
  .b-container-styling {
    align-items: center;
    width: fit-content;
    height: min-content;
    padding: 10px 40px;
    background-color: white;
    border: darkgrey 2px groove;
    border-radius: 7px;
    font-weight: bold;
  }
  .header {
    margin: 30px 20px;
  }

  .delete-button-done {
    background-color: lightgreen;
    border-color: lightgreen;
    padding: 0px;
    width: fit-content;
    height: 27px;
  }

  .delete-button {
    background-color: white;
    border-color: white;
    padding: 0px;
    width: fit-content;
    height: 27px;
  }
</style>
