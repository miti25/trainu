
document.addEventListener('turbolinks:load', function() {
  // テキストカウント要素
  // recipeタイトルカウント
  document.getElementById('recipe_title').onkeyup = function(e){
    const max = 30
    const text = e.target.value
    const LF_regex = new RegExp('\\n', 'g');
    const LF_count = text.match(LF_regex) == null ? 0 : text.match(LF_regex).length
    const word_count = max - text.length - LF_count
    document.getElementById('title_count').innerHTML = '残り' + word_count + '文字'
  };
  // recipe概要カウント
  document.getElementById('recipe_description').onkeyup = function(e){
    const max = 200
    const text = e.target.value
    const LF_regex = new RegExp('\\n', 'g');
    const LF_count = text.match(LF_regex) == null ? 0 : text.match(LF_regex).length
    const word_count = max - text.length - LF_count
    document.getElementById('description_count').innerHTML = '残り' + word_count + '文字'
  };
  // 画像表示要素
  const uploader = document.getElementById('recipe_uploader');
  const crear_btn = document.getElementById('crear_btn')
  const preview = document.getElementById('recipe_preview');
  // recipe画像プレビュー表示
  uploader.addEventListener('change', function() {
    const file = uploader.files[0];
    const reader = new FileReader();
    reader.readAsDataURL(file);
    reader.onload = function() {
      const image = reader.result;
      preview.setAttribute('src', image);
      preview.setAttribute('class', 'thumbnail');
    }
    crear_btn.innerHTML = 'X';
  });
  // サムネイル画像削除ボタン
  crear_btn.addEventListener('click', function(){
    uploader.value = ''
    uploader.dispatchEvent(new Event('change'));
    preview.setAttribute('src', '');
    preview.setAttribute('class', '');
    crear_btn.innerHTML = '';
  });
});
