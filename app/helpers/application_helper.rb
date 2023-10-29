module ApplicationHelper
  def default_meta_tags
    {
      site: '服カフェ',
      title: '服好き・カフェ好きのためのショップ検索サービス',
      reverse: true,
      charset: 'utf-8',
      description: '「服カフェ」では、セレクトショップ、カフェを同時に検索することができます。',
      keywords: 'セレクトショップ検索,カフェ検索,おしゃれカフェ,マップ検索',
      canonical: request.original_url,
      icon: [
        { href: image_url('logo.png'), sizes: '32x32' }
      ],
      og: {
        site_name: '服カフェ',
        title: '服好き・カフェ好きのためのショップ検索サービス',
        description: '「服カフェ」では、セレクトショップ、カフェを同時に検索することができます。',
        type: 'website',
        url: request.original_url,
        image: image_url('ogp1.png'),
        local: 'ja-JP'
      },
      twitter: {
        card: 'summary_large_image',
        image: image_url('ogp1.png')
      }
    }
  end
end
