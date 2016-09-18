// app/assets/javascripts/plugs.js
$(document).on('ready page:load', function () {
    
    // This function is used to control the edit plug modal dropdown
    $('#myModal').on("click", ".room-selection", function() {
        $("#edit-plug-room-dropdown").dropdown("toggle"); 
        $('#current-room-name').html($(this).html());
        
        $('#plug-room-id').attr("value", $(this).find("span:last").text());
        
        return false;
    });
});

