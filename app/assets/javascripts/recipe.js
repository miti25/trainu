
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
      }
    });
  document.querySelectorAll('.howto_uploader').forEach(function(a) {
    a.addEventListener('change', function() {
      const file = a.files[0];
      const reader = new FileReader();
      reader.readAsDataURL(file);
      reader.onload = function() {
        const image = reader.result;
        document.querySelector('.howto_preview').setAttribute('src', image);
      }
    });
  });
});
