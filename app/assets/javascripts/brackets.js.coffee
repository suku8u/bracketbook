# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

INITIAL_BRACKET_HEIGHT = 20
INITIAL_BRACKET_TOP_MARGIN_OFFSET = 10
INITIAL_MATCH_TOP_MARGIN_OFFSET = -2
BRACKET_WIDTH = 148
BRACKET_LEFT_MARGIN = 10

jQuery ->
  $('.alert').on 'click', '.close', (event) =>
    event.preventDefault()
    $(event.currentTarget).closest('.alert').hide()

jQuery ->
  $('#new_bracket input[type=submit].btn').hide()
  $('#edit-bracket').hide()
  $('#edit-bracket').bind 'click', (event) =>
    $('#new_bracket .field').slideDown()
    $('#new_bracket input[type=submit].btn').hide()
    $('#edit-bracket').hide()
    $('#generate-bracket').slideDown()

jQuery ->
  $('#generate-bracket').bind 'click', (event) =>
    # prevent default event
    event.preventDefault()

    # bracket name
    $('#bracket-name-box').empty().append($('#bracket_name').val())

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
      if bracket_team_names[_i * 2] != undefined
        m.team1 = bracket_team_names[_i * 2]
      else
        m.team1 = ""
      if bracket_team_names[_i * 2 + 1] != undefined
        m.team2 = bracket_team_names[_i * 2 + 1]
      else
        m.team2 = ""

    $('#bracket-box').empty().append(render_bracket(matches)).fadeIn(1000)
    $('#new_bracket .field').slideUp()
    $('#generate-bracket').hide()
    $('#new_bracket input[type=submit].btn').show()
    $('#edit-bracket').show()

# Match class
class Match
  constructor: (@team1 = "?", @team2 = "?") ->

  render_match: ->
    "#{@team1} vs #{@team2}"

# initialize match objects function
initialize_matches = (num_matches) ->
  matches = []
  for i in [0..num_matches-1]
    matches.push new Match
  return matches

# generate bracket
render_bracket = (matches) ->
  html = ""
  bracket_height = INITIAL_BRACKET_HEIGHT
  bracket_top_margin_offset = INITIAL_BRACKET_TOP_MARGIN_OFFSET
  match_top_margin_offset = INITIAL_MATCH_TOP_MARGIN_OFFSET
  first_round = true
  round_matches_hash = generate_round_matches_hash(matches.length)
  # iterate over round matches hash
  # shift elements off of matches based on matches in round
  # render round
  for round, matches_in_round of round_matches_hash
    bracket_height = bracket_height * 2
    bracket_top_margin_offset = bracket_top_margin_offset * 2
    match_top_margin_offset = match_top_margin_offset + 2
    matches_to_render = []
    for i in [1..matches_in_round]
      matches_to_render.push(matches.shift())
    html += render_round(matches_to_render, bracket_top_margin_offset, bracket_height, match_top_margin_offset)
  html += render_champion(matches.shift(), bracket_top_margin_offset * 2)
  return html

render_round = (matches, bracket_top_margin_offset, bracket_height, match_top_margin_offset) ->
  html = ""
  html += "<div style=\"height:auto; width:#{BRACKET_WIDTH}px; float:left; margin-top:-#{bracket_top_margin_offset}px\">"
  for match in matches
    html += render_match(match, bracket_height, match_top_margin_offset)
  html += "</div>"
  return html

render_match = (match, bracket_height, match_top_margin_offset) ->
  html = ""
  html += "<div style=\"width:#{BRACKET_WIDTH}px; height:#{bracket_height}px; position:relative; margin-top:#{match_top_margin_offset}px;\">
              <div style=\"position:absolute; bottom:0; left:#{BRACKET_LEFT_MARGIN}px;\">
                #{match.team1}
                </div>
          </div>"
  html += "<div style=\"width:#{BRACKET_WIDTH}px; height:#{bracket_height}px; border:1px solid black; border-left:none; position:relative;\">
              <div style=\"position:absolute; bottom:0; left:#{BRACKET_LEFT_MARGIN}px;\">
                #{match.team2}
              </div>
            </div>"
  return html

render_champion = (match, bracket_height) ->
  html = ""
  html += "<div style=\"height:auto; width: #{BRACKET_WIDTH}px; float:left;\">"
  html += "<div style=\"width:#{BRACKET_WIDTH}px; border-bottom: 1px solid #000; height:#{bracket_height}px; position:relative;\">
            <div style=\"position:absolute; bottom:0; left:#{BRACKET_LEFT_MARGIN}px;\">
              #{match.team1}
              </div>
          </div>"
  html += "</div>"


calculate_rounds = (num_matches) ->
  round_count = 0
  while num_matches >= 1
    num_matches = num_matches / 2
    round_count++
  return round_count

# generate a hash with round number as key and array of matches as value
generate_round_matches_hash = (num_matches) ->
  rounds = calculate_rounds(num_matches)
  round_matches_hash = {}
  round_number = 1
  while num_matches > 1
    num_matches = num_matches / 2
    round_matches_hash[round_number] = num_matches
    round_number++
  return round_matches_hash