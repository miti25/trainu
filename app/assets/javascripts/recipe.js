
document.addEventListener('turbolinks:load', function() {

  // recipe画像プレビュー表示
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
  // recipe概要テキスト数カウント
  document.querySelector('#recipe_description').onkeyup = function(e){
    const max = 200
    const word_count = max - e.target.value.length
    document.querySelector('#word_count').innerHTML = '残り' + word_count + '文字'
  };
  // howto画像プレビュー表示
  document.querySelectorAll('.howto_uploader').forEach(function(a){
    a.addEventListener('change', function(e) {
      const uploader = e.target
      const file = uploader.files[0];
      const reader = new FileReader();
      reader.readAsDataURL(file);
      reader.onload = function() {
        const image = reader.result;
        const preview = document.getElementById(`howto_preview_${uploader.id}`);
        preview.setAttribute('src', image);
        preview.setAttribute('class', 'mini d-block mx-auto');
      }
    });
  });
  // howto詳細文字数カウント
  document.querySelectorAll('.howto_description').forEach(function(a){
    a.onkeyup = function(e){
      const max = 100
      const word_count = max - e.target.value.length
      const index = e.target.id
      document.querySelector(`#word_count_${index}`).innerHTML = '残り' + word_count + '文字'
    };
  });
  // gem:cocoon 新規フォーム作成後
  jQuery('.links').on('cocoon:after-insert', function(e, insertedItem){
    const index = Number(jQuery('.order_num').eq(-2).val()) + 1;
    // 投稿フォーム新規追加下の画像プレビュー表示にかかる処理
    jQuery(insertedItem).find('.howto_uploader').attr('id', index);
    jQuery(insertedItem).find('.no_img').attr('id', 'howto_preview_' + index);
    // 表示順指定
    jQuery(insertedItem).find('.order_num').val(index);
    jQuery(insertedItem).removeClass('order-');
    jQuery(insertedItem).addClass(`order-${index}`);
    // word_count
    jQuery(insertedItem).find('.word_count').attr('id', 'word_count_' + index);
    //画像プレビュー表示
    jQuery(insertedItem).find('.howto_uploader').on('change', function(e){
      const file = e.target.files[0];
      const reader = new FileReader();
      reader.readAsDataURL(file);
      reader.onload = function() {
        const image = reader.result;
        const preview = jQuery(insertedItem).find('.howto_preview');
        preview.attr('src', image);
        preview.attr('class', 'mini d-block mx-auto');
      }
    });
    // 文字数カウント
    const howto_description = jQuery(insertedItem).find('.howto_description');
    howto_description.keyup(function(){
      const max = 100;
      const word_count = max - howto_description.val().length;
      jQuery(insertedItem).find('.word_count').html(`残り${word_count}文字`);
    });
  });
});
