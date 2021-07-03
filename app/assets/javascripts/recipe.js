
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

  // howtos表示制限
  const howtos_limit = 8
  let howtos_array = Array.from(document.querySelectorAll('.howto'))
  let howtos_length = howtos_array.length
  // 左右移動メソッド（move_range= 1(right) or -1(left)）
  function move_howto(obj, move_range){
    const target_howto = obj.target.closest('.howto');
    const original_index = howtos_array.findIndex(index => index == target_howto)
    const replaced_index = original_index + move_range
    const replace_howto = howtos_array[replaced_index]
    replace_howto.setAttribute('id', original_index);
    replace_howto.querySelector('.index_text').textContent = original_index + 1;
    replace_howto.setAttribute('class', `nested-fields howto col-3 mt-5 order-${original_index}`);

    target_howto.setAttribute('id', replaced_index);
    target_howto.querySelector('.index_text').textContent = replaced_index+ 1;
    target_howto.setAttribute('class', `nested-fields howto col-3 mt-5 order-${replaced_index}`);
    let end_index = []
    if(move_range == 1){
      end_index = original_index
      howtos_array.splice(original_index, 2, howtos_array[replaced_index], howtos_array[original_index])
    } else if(move_range == -1){
      end_index = replaced_index
      howtos_array.splice(replaced_index, 2, howtos_array[original_index], howtos_array[replaced_index])
    }
    if (end_index == 0){
      howtos_array[end_index].querySelector('.move_left').style.display ='none';
      howtos_array[end_index +1].querySelector('.move_left').style.display ='block';
    } else if (end_index + 1 == howtos_length -1) {
      howtos_array[end_index +1].querySelector('.move_right').style.display ='none';
      howtos_array[end_index].querySelector('.move_right').style.display ='block';
    };
  };

  if (howtos_length >= howtos_limit) document.getElementById('add_howto').style.display ='none';
  document.querySelectorAll('.move_left').forEach(function(a){
    if (a.closest('.order-0')) a.style.display ='none';
    a.addEventListener('click', function(e){
      move_howto(e, -1)
    });
  });
  document.querySelectorAll('.move_right').forEach(function(a){
    if (howtos_array.findIndex(index => index == a.closest('.howto')) + 1  == howtos_length){
      a.style.display ='none';
    };
    a.addEventListener('click', function(e){
      move_howto(e, 1)
    });
  });
  // howto画像プレビュー表示
  const howtos_uploader = document.querySelectorAll('.howto_uploader');
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
  const howtos_description = document.querySelectorAll('.howto_description');
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
    const removed_index =jQuery(removedItem).attr('id')
    jQuery(removedItem).removeClass()
    jQuery('.howto').each(function(key, a){
      const each_value = Number(jQuery(a).attr('id'))
      if (each_value > removed_index) {
        jQuery(a).attr('id', each_value - 1)
        jQuery(a).find('.index_text').text(each_value);
        jQuery(a).attr('class', `nested-fields howto col-3 mt-5 order-${each_value -1}`);
        if (jQuery(a).hasClass('order-0')) jQuery(a).find('.move_left').hide()
      };
    });
    if (removed_index < howtos_limit) jQuery('#add_howto').show();
    jQuery(removedItem).removeAttr('id')
    jQuery(`#${jQuery('.howto').length - 1}`).find('.move_right').hide()
  });

  // gem:cocoon 新規フォーム作成後
  jQuery('.links').on('cocoon:after-insert', function(e, insertedItem){
    howtos_array = jQuery('.howto').toArray()
    howtos_length = howtos_array.length
    const previous_index = jQuery('.howto').eq(-2).attr('id');
    // リミット到達時フォーム追加ボタン非表示
    if (previous_index >= howtos_limit - 2) jQuery('#add_howto').hide();
    if (jQuery('.howto').length == 1){
      var index =  0
    } else {
      var index = Number(previous_index) + 1
    };
    // 表示順指定
    jQuery(insertedItem).attr('id', index);
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
    jQuery(insertedItem).find('.move_left').on('click', function(e){
      move_howto(e, -1)
    });
    jQuery(insertedItem).find('.move_right').on('click', function(e){
      move_howto(e, 1)
    });
    //リミット時の左右移動キー表示
    if (jQuery(insertedItem).hasClass('order-0')) {
      jQuery(insertedItem).find('.move_left').hide()
    } else {
      jQuery('.howto').find('.move_right').show()
      jQuery(insertedItem).find('.move_right').hide()
    };
  });
});
