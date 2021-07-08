
document.addEventListener('turbolinks:load', function() {
  // recipe画像プレビュー表示
  const uploader = document.getElementById('recipe_uploader');
  uploader.addEventListener('change', function() {
    const file = uploader.files[0];
    const reader = new FileReader();
    reader.readAsDataURL(file);
    reader.onload = function() {
      const image = reader.result;
      const preview = document.getElementById('recipe_preview');
      preview.setAttribute('src', image);
      preview.setAttribute('class', 'thumbnail');
    }
  });
  // recipe概要テキスト数カウント
  document.querySelector('#recipe_description').onkeyup = function(e){
    const max = 200
    const word_count = max - e.target.value.length
    document.querySelector('#word_count').innerHTML = '残り' + word_count + '文字'
  };
});
