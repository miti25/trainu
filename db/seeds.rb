# coding: utf-8

#categoryは三段階に限定する。 親要素を筋群で分けた場合、子要素は個別の筋肉名称で止め、上部下部などに分けないこと。
  #例(腕：上腕二頭筋：長頭) (胸：大胸筋：上部)
shoulder = Category.create(name: '肩')
  deltoid = shoulder.children.create(name: '三角筋')
    %w[前部 背部 側部].each do |name|
      deltoid.children.create(name: name)
    end

arm = Category.create(name: '腕')
  biceps_brachii, triceps_brachii = arm.children.create(
    [
      {name: '上腕二頭筋'},
      {name: '上腕三頭筋'},
    ]
  )
    %w[長頭 短頭].each do |name|
      biceps_brachii.children.create(name: name)
    end
    %w[長頭 短頭 外側頭].each do |name|
      triceps_brachii.children.create(name: name)
    end

chest = Category.create(name: '胸')
  pectoralis_major, pectoralis_minor, serratus_anterior = chest.children.create(
    [
      {name: '大胸筋'},
      {name: '小胸筋'},
      {name: '前鋸筋'},
    ]
  )
    %w[上部 中部 下部].each do |name|
      pectoralis_major.children.create(name: name)
    end

abdominal = Category.create(name: '腹')
  rectus_abdominis, obliquus_externus_abdominis, obliquus_internus_abdomini, transversus_abdominis = abdominal.children.create(
    [
      {name: '腹直筋'},
      {name: '外腹斜筋'},
      {name: '内腹斜筋'},
      {name: '腹横筋'},
    ]
  )
    %w[上部 中部 下部].each do |name|
      rectus_abdominis.children.create(name: name)
    end

back = Category.create(name: '背中')
  trapezius, latissimus, erector_spinae = back.children.create(
    [
      {name: '僧帽筋'},
      {name: '広背筋'},
      {name: '脊柱起立筋'},
    ]
  )
    %w[上部 中部 下部].each do |name|
      trapezius.children.create(name: name)
    end
    %w[上部 下部].each do |name|
      latissimus.children.create(name: name)
    end

buttocks = Category.create(name: '尻')
  gluteus_maximus = buttocks.children.create(name: '大臀筋')

thigh = Category.create(name: '太もも')
  quadriceps_femoris, hamstring, adductor = thigh.children.create(
    [
      {name: '大腿四頭筋'},
      {name: 'ハムストリングス'},
      {name: '内転筋'},
    ]
  )
    %w[大腿直筋 内側広筋 外側広筋 中間広筋].each do |name|
      quadriceps_femoris.children.create(name: name)
    end
    %W[大腿二頭筋長頭 大腿二頭筋短頭 半膜様筋 半腱様筋].each do |name|
      hamstring.children.create(name: name)
    end

calf = Category.create(name: 'ふくらはぎ')
  gastrocnemius, soleus = calf.children.create(
    [
      {name: '腓腹筋'},
      {name: 'ヒラメ筋'},
    ]
  )
    %w[内側頭 外側頭].each do |name|
      gastrocnemius.children.create(name: name)
    end