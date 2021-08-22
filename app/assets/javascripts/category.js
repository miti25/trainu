document.addEventListener('turbolinks:load', function() {
  //カテゴリー選択のドロップダウン機能
  document.querySelectorAll('.category_dropdown').forEach(function(a){
    a.addEventListener('click', function(){
      const parent = a.closest('.parent_list')
      const child = parent.querySelector('.child_list')
      if (parent.classList.contains('displaied')){
        child.style.display= 'none';
        parent.classList.remove('displaied');
        a.innerHTML = '▶'
      } else {
        child.style.display= 'block';
        parent.classList.add('displaied');
        a.innerHTML = '▼'
      };
    });
  });
  // レシピ編集ページ
  const more_muscle = document.getElementById('more_muscle')
  const main_selection = document.getElementById('main_selection')
  const detail_selection = document.getElementById('detail_selection')
  more_muscle.addEventListener('click', function(){
    main_selection.classList.toggle('toggle_none');
    if (main_selection.classList.contains('toggle_none')){
      more_muscle.innerHTML = '選択肢を減らす';
      detail_selection.style.display = 'block';
      document.querySelectorAll('.child_checkbox').forEach(function(a){
        if (a.checked){
          const parent_list = a.closest('.parent_list')
          a.closest('.child_list').style.display = 'block';
          parent_list.classList.add('displaied');
          parent_list.querySelector('.category_dropdown').innerHTML = '▼';
        };
      });
    } else {
      detail_selection.style.display = 'none';
      more_muscle.innerHTML = '筋肉ごとに選択';
    };
  });

  //チェックボックス連動
  main_selection.addEventListener('change', function(a){
    const main_value = a.target.value;
    if (a.target.checked){
      detail_selection.querySelector(`#category_${main_value}`).checked =true;
    } else{
      detail_selection.querySelector(`#category_${main_value}`).checked =false;
    }
  });
  detail_selection.querySelector('.root_category').addEventListener('change', function(a){
    const detail_value = a.target.value;
    if (a.target.checked){
      main_selection.querySelector(`#category_${detail_value}`).checked =true;
    } else{
      main_selection.querySelector(`#category_${detail_value}`).checked =false;
    }
  });
});