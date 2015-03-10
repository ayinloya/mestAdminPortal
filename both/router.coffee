Router.configure
  layoutTemplate: 'layoutTemplate'
  loadingTemplate: 'loadingTemplate'
  notFoundTemplate: 'notFoundTemplate'
  routeControllerNameConverter: "camelCase"

userHookFunction = () ->
  if !Meteor.userId()
    Router.go('sign-in')
  else
    this.next()

noLoginPageHookFunction = () ->
  if Meteor.userId()
    Router.go 'dashboard'
  else
    this.next()

Router.onBeforeAction noLoginPageHookFunction,
  only: ['sign-in']
  
# OnBefore action hooks
Router.onBeforeAction userHookFunction,
  only: ['dashboard', 'prospects', 'prospectsCategory', 
  'allApplicants', 'allEits', 'allAlumni', 
  'newApplicant', 'editEit', 'newEit', 'settings', 'editApplicant']

Router.route '/', () ->
  # this.render('home')
  Router.go 'sign-in'
  return
, name: 'home'

# Sign In
Router.route '/sign-in', () ->
  this.render('signIn')
  return
, name: 'sign-in'


# Dashboard
Router.route '/dashboard',  () -> 
  this.render 'dashboard'
  this.layout 'dashboardLayout'
  return
, name: 'dashboard'

# Dashboard {profile}
Router.route '/user_settings', () ->
  this.render 'userSettings'
  this.layout 'dashboardLayout'
  return
,
  name: 'userSettings'

# Dashboard {records}
Router.route '/records', () ->
  this.render 'systemRecords'
  this.layout 'dashboardLayout'
  return
, 
  name: 'records'
  
# Dashboard {allProspects}
Router.route '/prospects', () ->
  this.render('prospects')
  this.layout('dashboardLayout')
  return
, 
  name: 'prospects',
  data: () ->
    return {
      prospects: Prospects.find().fetch(),
      eits: Prospects.find({category: 'eit'}).fetch(),
      fellows: Prospects.find({category: 'fellow'}).fetch(),
      staffs: Prospects.find({category: 'staff'}).fetch(),
      investors: Prospects.find({category: 'investor'}).fetch(),
      others: Prospects.find({category: 'others'}).fetch()
    }


Router.route '/prospects/:category/', ()->
  this.layout('dashboardLayout');
  this.render('prospects'); # calling projects template
  return 
,
  name: 'prospectsCategory',
  data: () ->
    return  prospects: Prospects.find({category: this.params.category}).fetch()


# Dashboard {allApplicants}
Router.route '/applicants', () ->
  this.render('applicants');
  this.layout('dashboardLayout');
  return
,
  name: 'allApplicants'


# Dashboard {allEits}
Router.route '/all_eits', () ->
  this.render('allEits');
  this.layout('dashboardLayout');
,
  name: 'allEits'


# Dashboard {allAlumni}
Router.route '/alumni', () ->
  this.render('alumni');
  this.layout('dashboardLayout');
  return
,
  name: 'allAlumni'


# Dashboard {newEit}
Router.route '/new/eit', ()->
  this.render('newEit');
  this.layout('dashboardLayout');
  return
,
  name: 'newEit'


# Dashboard {newApplicant}
Router.route '/new/applicant', () ->
  this.render('newApplicant');
  this.layout('dashboardLayout');
  return
,
  name: 'newApplicant'


# Dashboard {editApplicant}
Router.route '/edit/applicant/:_id', () ->
  this.render('updateApplicant')
  this.layout('dashboardLayout')
  return
,
  name: 'editApplicant',
  data: () ->
    id = this.params._id;
    data = Applicants.findOne _id: id
    return data: data


# Dashboard {editEit}
Router.route '/edit/eit/:_id', () ->
  this.render('updateEit');
  this.layout('dashboardLayout');
  return
,
  name: 'editEit',
  data: () ->
    id = this.params._id
    data = Eits.findOne _id: id
    return data: data


# Dashboard {settings}
Router.route '/settings/:_id', () ->
  this.render('settings')
  this.layout('dashboardLayout')
  return
,
  name: 'settings',
  data: ()->
    id = this.params._id
    Session.set('settingsPage', 'nstage') if id == 'newStage'
    Session.set('settingsPage', 'nsettings') if id == 'newSettings'

    if id != 'newStage' && id != 'settings' && id != 'newSettings'
      data = Settings.findOne _id: id
      Session.set('settingsId', id)
      id = 'updateSettings';

    return template: id, dataContext: data