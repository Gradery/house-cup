//= require application
var suggestionData;
var suggestionDataRaw;

$(document).ready(function(){
    animate($("#score-1"));
    animate($("#score-2"));
    animate($("#score-3"));
    animate($("#score-4"));
    animate($("#score-5"));
    animate($("#score-6"));

    $(".item").click(function(){
    	$(".act").removeClass("act");
    	$(this).find("img").addClass("act");
        getStudents();
    });

    $("#submit").click(function(){
        //see if they have custom points turned on
    	if ($(".active").length > 0)//custom points is on
        {
            if ( $(".active")[1].id === "list" )
            {
                count = $("#times_list").val()
                if (count != "" && count != undefined) {
                    for (var i = 0; i < parseInt(count); i++)
                    {
                        submitSelectedPoints();
                    }
                }
                else
                    submitSelectedPoints();
            }
            else
            {
                count = $("#times_custom").val()
                if (count != "" && count != undefined)
                {
                    for (var i = 0; i < parseInt(count); i++)
                    {
                        submitCustomPoints();
                    }
                }
                else
                    submitCustomPoints();
            }
        }
        else //just subimt normal points
        {
            count = $("#times_list").val()
            if (count != "" && count != undefined)
            {
                for (var i = 0; i < parseInt(count); i++)
                {
                    submitSelectedPoints();
                }
            }
            else
                submitSelectedPoints();
        }
    });

    getStudents();

    $('.typeahead').on('typeahead:select', function(ev, suggestion) {
      console.log('Selection: ' + suggestion);
      console.log(ev);
      id = suggestion.replace(")","").split("(")[1];
      //use the Badge ID to find the actual id and put them in the list of users
      for (var i = 0; i < suggestionDataRaw.length; i++)
      {
        if (suggestionDataRaw[i].badge_id === id)
        {
            //don't add the same student multiple times
            console.log($("#member_" + suggestionDataRaw[i].id))
            if ($("#member_" + suggestionDataRaw[i].id).length === 0)
            {
                $("#studentListSet").append("<div id='member_"+suggestionDataRaw[i].id+"'><a href='#' class='delete_member'><span class='glyphicon glyphicon-remove'>&nbsp;</span></a>"+suggestion+"</div>");
                $("#studentListCustom").append("<div id='member_"+suggestionDataRaw[i].id+"'><a href='#' class='delete_member'><span class='glyphicon glyphicon-remove'></span></a>"+suggestion+"</div>");

                $(".delete_member").click(function(e){
                    e.preventDefault();
                    console.log("clicked to delete a member");
                    console.log($(e.currentTarget).parent().attr("id"));
                    $(e.currentTarget).parent().remove();
                    $("#"+$(e.currentTarget).parent().attr("id")).remove();
                });
            }
            $('.typeahead').typeahead('val', '');
            break;
        }
      }
    });

    //onboarding functions
    $("#invite").click(function(){
        studentId = $("#studentId").val();
        name = $("#name").val();
        if (studentId !== "")
        {
            $.post(window.location.pathname, {
                student_id: studentId,
                name: name
            })
            .success(function(data){
                $("#studentId").val("");
                $("#name").val("");
                toastr.success("Student Added!");
            })
            .error(function(error){
                console.log(error);
                toastr.error("ERROR: Couldn't add student. Please try again.")
            })
        }
    });
});
function submitCustomPoints(){
    house = $(".act").attr("id");
    title = $("#title").val();
    amount = $("#amount").val();
    note = $("#note_custom").val();
    console.log(house + " - " + title + " - " + amount);
    var children = $("#studentListCustom").children();
    var members = [];
    for (var i = 0; i < children.length; i++)
    {
        members.push($(children[i]).attr("id").replace("member_",""));
    }
    if (title == "" || amount == "")
        toastr.error("Please fill out the Title and Amount fields to Submit Points");
    else
    {
        $.post(window.location.pathname, {
            custom_points: true,
            house: house,
            title: title,
            amount: amount,
            note: note,
            member_ids: members
        })
        .success(function(data){
            $(".item img").removeClass("act");
            $("#activity").val("");
            $("#note_list").val("");
            $("#grade").val("");
            $("#title").val("");
            $("#note_custom").val("");
            $("#amount").val("");
            $("#gradeCustom").val("");
            $("#member_id_custom").val("");
            $('#studentCustom').typeahead('val', "");
            $('#times_custom').val("");
            $("#studentListCustom").html("");
            $("#studentListSet").html("");
            toastr.success("Points Submitted");
        })
        .error(function(error){
            console.log(error);
            if (error.status == 400)
                toastr.error(error.responseJSON.error);
            else
                toastr.error("ERROR: Couldn't submit the points. Please try again later.");
        })
    }
}

function submitSelectedPoints(){
    house = $(".act").attr("id");
    activityId = $("#activity").val();
    note = $("#note_list").val();
    console.log(house + " - " + activityId + " - " + note);
    console.log($("#studentListSet").children());
    var children = $("#studentListSet").children();
    var members = [];
    for (var i = 0; i < children.length; i++)
    {
        members.push($(children[i]).attr("id").replace("member_",""));
    }
    $.post(window.location.pathname, {
        custom_points: false,
        house: house,
        activity: activityId,
        note: note,
        member_ids: members
    })
    .success(function(data){
        $(".item img").removeClass("act");
        $("#activity").val("");
        $("#note_list").val("");
        $("#grade").val("");
        $("#title").val("");
        $("#note_custom").val("");
        $("#amount").val("");
        $("#gradeList").val("");
        $("#member_id_list").val("");
        $('#studentList').typeahead('val', "");
        $('#times_list').val("");
        $("#studentListSet").html("");
        $("#studentListCustom").html("");
        toastr.success("Points Submitted");
    })
    .error(function(error){
        console.log(error);
        if (error.status == 400)
            toastr.error(error.responseJSON.error);
        else
            toastr.error("ERROR: Couldn't submit the points. Please try again later.");
    })
}

function getStudents()
{
    $.get("/students?house="+$(".act").attr("id"))
    .success(function(data){
        console.log(data);

        suggestionDataRaw = data;
        suggestionData = [];
        for(var i = 0; i < data.length; i++)
        {
            suggestionData.push(data[i].name + " (" + data[i].badge_id + ")");
        }
        console.log(suggestionData);

        var bh = new Bloodhound({
          datumTokenizer: Bloodhound.tokenizers.whitespace,
          queryTokenizer: Bloodhound.tokenizers.whitespace,
          local: suggestionData
        });
        $('.typeahead').typeahead('destroy'); //in case it's already been instantiated
        $('.typeahead').typeahead({
          hint: true,
          highlight: true,
          minLength: 1
        },
        {
          name: 'students',
          source: bh
        });
        $(".typeahead").val("");
        $(".twitter-typeahead").css("width", "100%");
        $(".twitter-typeahead").children().css("width", "100%");
        $(".tt-menu").css("background-color","white").css("padding","5px").css("border","2px solid black").css("border-radius","5px");
    })
    .error(function(data){
        console.log("error!");
        console.log(data);
    })
}

function animate(item){
	var skillBar = item.children().find('.inner');
    var skillVal = skillBar.attr("data-progress");
    $(skillBar).animate({
        height: skillVal
    }, 1500);
}