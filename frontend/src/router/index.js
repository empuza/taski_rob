import Vue from 'vue'
import Router from 'vue-router'
import Signin from '@/components/Signin'
import Signup from '@/components/Signup'
import Tasks from '@/components/Tasks'
import ForgotPassword from '@/components/ForgotPassword'
import ResetPassword from '@/components/ResetPassword'
import Activation from '@/components/Activation'
import ChangePassword from '@/components/ChangePassword'
import UserDetails from '@/components/UserDetails'
import UsersList from '@/components/admin/users/List'
import UserTasksList from '@/components/admin/users/tasks/List'
import UserEdit from '@/components/admin/users/Edit'

Vue.use(Router)

export default new Router({
  mode: 'history',
  routes: [
    {
      path: '/',
      name: 'Signin',
      component: Signin
    },
    {
      path: '/signup',
      name: 'Signup',
      component: Signup
    },
    {
      path: '/tasks',
      name: 'Tasks',
      component: Tasks
    },
    {
      path: '/forgot_password',
      name: 'ForgotPassword',
      component: ForgotPassword
    },
    {
      path: '/password_resets/:token',
      name: 'ResetPassword',
      component: ResetPassword
    },
    {
      path: '/activate_account/:token',
      name: 'Activation',
      component: Activation
    },
    {
      path: '/change_password',
      name: 'ChangePassword',
      component: ChangePassword
    },
    {
      path: '/user_details',
      name: 'UserDetails',
      component: UserDetails
    },
    {
      path: '/admin/users',
      name: 'UsersList',
      component: UsersList
    },
    {
      path: '/admin/users/:id/tasks',
      name: 'UserTasksList',
      component: UserTasksList
    },
    {
      path: '/admin/users/:id',
      name: 'UserEdit',
      component: UserEdit
    }
  ]
})
