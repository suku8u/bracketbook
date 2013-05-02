# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
  $('#new_bracket input[type=submit].btn').bind 'click', (event) =>
    # prevent default event
    event.preventDefault()

    # value from text area, teams separated by line break
    bracket_teams_string = $('#bracket_bracket_teams').val()

    # array of team names
    bracket_team_names = bracket_teams_string.split(/\r?\n/)

    # number of teams
    num_teams = bracket_team_names.length

    # choose minimum number of matches for symmetrical bracket
    num_matches = switch
      when num_teams <= 4 then 4
      when num_teams <= 8 then 8
      when num_teams <= 16 then 16
      when num_teams <= 32 then 32
      else 0

    # call initialize_matches
    matches = initialize_matches num_matches

    # insert two teams into each match
    for m in matches
      m.team1 = bracket_team_names[_i*2]
      m.team2 = bracket_team_names[_i*2+1]

    $('#bracket-box').append(generate_bracket(matches))

    # testing
    console.log("bracket_team_names")
    console.log(bracket_team_names)
    console.log("num_teams")
    console.log(num_teams)
    console.log("num_matches")
    console.log(num_matches)
    console.log("matches")
    console.log(matches)
    console.log("render_match")
    console.log(matches[0].render_match())

# Match class
class Match
  constructor: (@team1, @team2) ->

  render_match: ->
    "#{@team1} vs #{@team2}"

# initialize match objects function
initialize_matches = (num_matches) ->
  matches = []
  for num in [0..num_matches-1]
    matches.push new Match
  return matches

# generate bracket
generate_bracket = (matches) ->
  html = ""
  bracket_height = 20
  bracket_top_margin_offset = 10
  bracket_top_margin_offset = bracket_top_margin_offset * 2
  html += "<div style=\"height:auto; width: 200px; float:left; margin-top:-#{bracket_top_margin_offset}px\">"
  for match in matches
    bracket_height = bracket_height * 2
    html += render_match(match, bracket_height)
  return html

render_match = (match, bracket_height) ->
  html = ""
  html += "<div style=\"width:200px; height:#{bracket_height}px; position:relative;\">
              <div style=\"position:absolute; bottom:0; left:20px;\">
                #{match.team1}
                </div>
          </div>"
  html += "<div style=\"width:200px; height:#{bracket_height}px; border:2px solid black; border-left:none; position:relative;\">
              <div style=\"position:absolute; bottom:0; left:20px;\">
                #{match.team2}
              </div>
            </div>"
  return html