$(function() {
    var rotatedOnce = false;
    //$(".ui-slider-handle").draggable();

    var input = document.getElementById('input-upload');
    input.addEventListener('change', handleFiles);

    var canvas = document.getElementById('leaf-canvas');
    var ctx = document.getElementById('leaf-canvas').getContext('2d');
    var leafColor = {};
    leafColor.red = 166;
    leafColor.green = 208;
    leafColor.blue = 30;
    $("#color-slider").slider({
        min: 1,
        max: 120,
        value: 50,
        slide: function(event, ui) {
            //$("#minval").val(ui.value);
            console.log(ui.value);
            recolorCanvas(canvas, ctx, ui.value / 360, leafColor);
            window.sunLight = ui.value / 120
        }
    });

    function handleFiles(e) {
        var img = new Image();
        img.onload = function() {

            if (!rotatedOnce) {
                
                ctx.translate(canvas.width / 2, canvas.height / 2);

                ctx.rotate(Math.PI / 2);
                ctx.translate(-canvas.width / 2, -canvas.width / 2);
            }


            ctx.drawImage(this, 0, 0, this.width, this.height, 0, 0, canvas.width, canvas.height);
            rotatedOnce = true;
            //ctx.setTransform(1, 0, 0, 1, 0, 0);
            //ctx.drawImage(img, 0, 0, 100, 75);

        }
        img.src = URL.createObjectURL(e.target.files[0]);
    }

    var img = new Image();
    img.onload = function() {
        //$("#photo-capture").addClass("hidden");
        canvas.width = this.naturalWidth;
        canvas.height = this.naturalHeight;

        ctx.drawImage(this, 0, 0, this.width, this.height);


    }
    img.src = "https://group2-final-beyhum.c9users.io/assets/default-leaf.jpg";

});
