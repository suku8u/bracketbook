module BracketsHelper
  def win_loss_indicator(team_a_score, team_b_score, team_a_name, team_b_name)
    class_string = ""
    case
    when team_a_score > team_b_score
      class_string += "badge-success"
    when team_b_score > team_a_score
      class_string += "badge-important"
    else
      ""
    end
    if team_a_name.downcase == "bye" || team_b_name.downcase == "bye"
      class_string += " hidden"
    end
    return class_string
  end

  def show_team team_name, team_edit_path, allow_edit
    if allow_edit
      return link_to team_name, team_edit_path
    else
      return team_name
    end
  end
end
