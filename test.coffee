@Contacts = new Meteor.Collection('contacts')

@preg_quote = (str, delimiter) ->
  (str + '').replace(new RegExp('[.\\\\+*?\\[\\^\\]$(){}=!<>|:\\' + (delimiter || '') + '-]', 'g'), '\\$&')

if Meteor.isServer
  Meteor.publish 'contacts', (q) ->
    r = new RegExp '^' + preg_quote(q), 'i'
    
    # this doesn't work:
    c = Contacts.find {'$or': [ {firstName: r}, {lastName: r} ] }
    
    # this does work:
    # c = Contacts.find { firstName: r }

    results = _.map c.fetch(), (a) ->
      a.firstName + ' ' + a.lastName

    console.log 'Filtering by "' + q + '" gives ' + c.count() + ' results: ' + results.join(", ")

    c    

  if Contacts.find().count() == 0
    Contacts.insert
      firstName: 'Albert'
      lastName: 'Einstein'

    Contacts.insert
      firstName: 'Bruce'
      lastName: 'Willis'

    Contacts.insert
      firstName: 'David'
      lastName: 'Brown'

    Contacts.insert
      firstName: 'Chris'
      lastName: 'Rock'

if Meteor.isClient 
  Deps.autorun ->
    Meteor.subscribe 'contacts', Session.get('search')

  Template.searchbox.helpers
    query: ->
      Session.get('search');
    contacts: ->
      r = new RegExp '^' + preg_quote(Session.get('search')), 'i'
      
      # this doesn't work:
      c = Contacts.find {'$or': [ {firstName: r}, {lastName: r} ] }
      
      # this does work:
      # c = Contacts.find { firstName: r }

      results = _.map c.fetch(), (a) ->
        a.firstName + ' ' + a.lastName

      console.log 'Filtering by "' + Session.get('search') + '" gives ' + c.count() + ' results: ' + results.join(", ")

      c
      
  Template.searchbox.events
    'click .links a': (e) ->
      e.preventDefault()
      Session.set 'search', e.target.innerHTML