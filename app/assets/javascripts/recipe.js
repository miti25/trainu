
document.addEventListener('turbolinks:load', function() {
  document.querySelectorAll('.delete').forEach(function(a) {
    a.addEventListener('ajax:success', function() {
      a.style.display = 'none';
    });
  });
  document.querySelectorAll('.image').forEach(function(a) {
    a.addEventListener('ajax:success', function() {

    })
  });
  const uploader = document.querySelector('.recipe_uploader');
    uploader.addEventListener('change', function() {
      const file = uploader.files[0];
      const reader = new FileReader();
      reader.readAsDataURL(file);
      reader.onload = function() {
        const image = reader.result;
        document.querySelector('.recipe_preview').setAttribute('src', image);
        document.querySelector('.recipe_preview').setAttribute('class', 'thumbnail');
      }
    });
  document.querySelectorAll('.howto_uploader').forEach(function(a) {
    a.addEventListener('change', function(e) {
      const target = document.querySelector('.update_btn')
      console.log(target.className)
      if (e.target.files[0].size > 0) {
        $(this).parents('form').submit();
      }
    });
  });
  const howtos = Array.from(document.querySelectorAll('.howto_uploader'));
  howtos.forEach(function(h) {
    h.addEventListener('click', function(e) {
      const index = howtos.findIndex(howto => howto === e.target);
      console.log(index);
    });
  });
});
