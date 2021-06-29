
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

  const howtos_limit = 8
  if (document.querySelectorAll('.howto').length >= howtos_limit) document.getElementById('add_howto').style.display ='none';

  document.querySelectorAll('.move_left').forEach(function(a){
    if (a.closest('.order-0')) a.style.display ='none';
    a.addEventListener('click', function(e){
      const target_howto = e.target.closest('.howto');
      const number = Number(target_howto.querySelector('.order_num').value);
      const previous_howto = document.querySelector(`.order-${number - 1}`)
      target_howto.querySelector('.order_num').setAttribute('value', number - 1);
      target_howto.querySelector('.index_text').textContent = number;
      target_howto.setAttribute('class', `nested-fields howto col-3 mt-5 order-${number - 1}`);
      previous_howto.querySelector('.order_num').setAttribute('value', number);
      previous_howto.querySelector('.index_text').textContent = number + 1;
      previous_howto.setAttribute('class', `nested-fields howto col-3 mt-5 order-${number}`);
      if (target_howto.classList.contains('order-0')){
        a.style.display ='none';
        previous_howto.querySelector('.move_left').style.display ='block';
      } else if (previous_howto.classList.contains(`order-${howtos_limit - 1}`)){
        target_howto.querySelector('.move_right').style.display ='block';
        previous_howto.querySelector('.move_right').style.display ='none';
      };
    });
  });
  document.querySelectorAll('.move_right').forEach(function(a){
    if (a.closest(`.order-${howtos_limit - 1}`)) a.style.display ='none';
    a.addEventListener('click', function(e){
      const target_howto = e.target.closest('.howto');
      const number = Number(target_howto.querySelector('.order_num').value);
      const next_howto = document.querySelector(`.order-${number + 1}`)
      target_howto.querySelector('.order_num').setAttribute('value', number + 1);
      target_howto.querySelector('.index_text').textContent = number + 2;
      target_howto.setAttribute('class', `nested-fields howto col-3 mt-5 order-${number + 1}`);
      next_howto.querySelector('.order_num').setAttribute('value', number);
      next_howto.querySelector('.index_text').textContent = number + 1;
      next_howto.setAttribute('class', `nested-fields howto col-3 mt-5 order-${number}`);
      if (target_howto.classList.contains(`order-${howtos_limit -1}`)){
        a.style.display ='none';
        next_howto.querySelector('.move_right').style.display ='block';
      } else if (next_howto.classList.contains('order-0')){
        target_howto.querySelector('.move_left').style.display ='block';
        next_howto.querySelector('.move_left').style.display ='none';
      };
    });
  });
  // howto画像プレビュー表示
  const howtos_uploader = Array.from(document.querySelectorAll('.howto_uploader'));
  howtos_uploader.forEach(function(a){
    a.addEventListener('change', function(e) {
      const file = e.target.files[0];
      const reader = new FileReader();
      reader.readAsDataURL(file);
      reader.onload = function() {
        const image = reader.result;
        const preview = e.target.closest('.howto').querySelector('.howto_preview')
        preview.setAttribute('src', image);
        preview.setAttribute('class', 'howto_preview mini d-block mx-auto');
      }
    });
  });
  // howto詳細文字数カウント
  const howtos_description = Array.from(document.querySelectorAll('.howto_description'));
  howtos_description.forEach(function(a){
    a.onkeyup = function(e){
      const max = 100;
      const word_count = max - e.target.value.length;
      const counter = e.target.closest('.howto').querySelector('.word_count');
      counter.innerHTML = '残り' + word_count + '文字';
    };
  });
  // gem:cocoon フォーム削除後
  jQuery('#howtos_area').on('cocoon:after-remove', function(e, removedItem){
    const removed_index = jQuery(removedItem).find('.order_num').val()
    jQuery(removedItem).removeClass()
    jQuery('.howto').each(function(key, a){
      const each_value = jQuery(a).find('.order_num').val()
      if (each_value >= removed_index) {
        jQuery(a).find('.order_num').val(each_value - 1);
        jQuery(a).find('.index_text').text(each_value);
        jQuery(a).attr('class', `nested-fields howto col-3 mt-5 order-${each_value -1}`);
      };
    });
    if (removed_index < howtos_limit) jQuery('#add_howto').show();
  });
  // gem:cocoon 新規フォーム作成後
  jQuery('.links').on('cocoon:after-insert', function(e, insertedItem){
    if (jQuery('.order_num').eq(-2).val() >= howtos_limit - 2) jQuery('#add_howto').hide();
    const preview_index = jQuery('.order_num').eq(-2).val();
    if (preview_index == null || preview_index == 'new_howtos'){
      var index =  0
    } else {
      var index = Number(preview_index) + 1
    };
    // 表示順指定
    jQuery(insertedItem).find('.order_num').val(index);
    jQuery(insertedItem).find('.index_text').text(index + 1);
    jQuery(insertedItem).removeClass('order-');
    jQuery(insertedItem).addClass(`order-${index}`);
    //画像プレビュー表示
    jQuery(insertedItem).find('.howto_uploader').on('change', function(e){
      const file = e.target.files[0];
      const reader = new FileReader();
      reader.readAsDataURL(file);
      reader.onload = function() {
        const image = reader.result;
        const preview = jQuery(insertedItem).find('.howto_preview');
        preview.attr('src', image);
        preview.attr('class', 'howto_preview mini d-block mx-auto');
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
