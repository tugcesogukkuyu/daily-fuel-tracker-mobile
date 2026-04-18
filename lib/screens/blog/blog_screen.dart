import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import 'blog_detail_screen.dart';

class BlogScreen extends StatelessWidget {
  const BlogScreen({super.key});

  void _openBlogDetail(BuildContext context, _BlogPost post) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlogDetailScreen(
          title: post.title,
          category: post.category,
          description: post.description,
          color: post.color,
          sections: post.sections,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<_BlogPost> blogPosts = _blogPosts;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _BlogHeader(onBackPressed: () => Navigator.pop(context)),
              const SizedBox(height: 14),
              const Text(
                'Beslenme İçeriklerini Keşfet',
                style: TextStyle(
                  color: AppColors.textDark,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Farklı beslenme yaklaşımları hakkında hazırlanan içeriklere göz atın.',
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              const _OnlyAllChip(),
              const SizedBox(height: 12),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.only(bottom: 100),
                  itemCount: blogPosts.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 8,
                    childAspectRatio: 0.62,
                  ),
                  itemBuilder: (context, index) {
                    final _BlogPost post = blogPosts[index];

                    return _BlogCard(
                      post: post,
                      onTap: () => _openBlogDetail(context, post),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BlogHeader extends StatelessWidget {
  final VoidCallback onBackPressed;

  const _BlogHeader({required this.onBackPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: onBackPressed,
          style: IconButton.styleFrom(
            backgroundColor: AppColors.card,
            fixedSize: const Size(34, 34),
          ),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.accentBlue,
            size: 16,
          ),
        ),
        const SizedBox(width: 8),
        const Expanded(
          child: Text(
            'Diyet ve Beslenme Blogu',
            style: TextStyle(
              color: AppColors.textDark,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}

class _OnlyAllChip extends StatelessWidget {
  const _OnlyAllChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 31,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Text(
        'Tümü',
        style: TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _BlogCard extends StatelessWidget {
  final _BlogPost post;
  final VoidCallback onTap;

  const _BlogCard({
    required this.post,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 62,
              width: double.infinity,
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: post.color,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(8),
                ),
              ),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  post.title.toUpperCase(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    height: 1.05,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 7, 8, 7),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.textDark,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Expanded(
                      child: Text(
                        post.description,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 9,
                          height: 1.25,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Text(
                      'Devamını Oku ›',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BlogPost {
  final String title;
  final String category;
  final String description;
  final Color color;
  final List<BlogContentSection> sections;

  const _BlogPost({
    required this.title,
    required this.category,
    required this.description,
    required this.color,
    required this.sections,
  });
}

const List<_BlogPost> _blogPosts = [
  _BlogPost(
    title: 'Ketojenik Beslenme',
    category: 'Ketojenik Beslenme',
    description: 'Karbonhidratı azaltıp enerjiyi yağlardan almaya dayanan beslenme modeli.',
    color: Color(0xFF7BAE7F),
    sections: [
      BlogContentSection(
        heading: 'Ketojenik Beslenme Nedir?',
        paragraphs: [
          'Ketojenik beslenme, karbonhidrat tüketimini ciddi şekilde azaltıp, enerjinin büyük kısmını yağlardan elde etmeye dayanan bir beslenme modelidir. Bu düzende vücut, normalde kullandığı glikoz yerine “keton” adı verilen alternatif bir yakıtı üretir ve buna ketozis durumu denir. Amaç; kan şekeri dalgalanmalarını azaltmak, yağ yakımını artırmak ve daha stabil bir enerji seviyesine ulaşmaktır.',
        ],
      ),
      BlogContentSection(
        heading: 'Ne Yenir? Nasıl Bir Plan Oluşturabilirsin?',
        paragraphs: [
          'Ketojenik beslenmede temel mantık:',
          'düşük karbonhidrat + yüksek yağ + yeterli protein',
          'Başlamak için şu tarz bir yol izleyebilirsin:',
        ],
        bullets: [
          'Yağ kaynakları: Zeytinyağı, tereyağı, avokado, Hindistan cevizi yağı',
          'Protein: Yumurta, kırmızı et, tavuk, balık',
          'Sebzeler: Brokoli, kabak, ıspanak, salatalık, marul',
          'Atıştırmalık: Badem, ceviz, fındık',
          'Süt ürünleri: Tam yağlı peynir, şekersiz yoğurt',
          'Kahvaltı: Yumurtalı avokado + zeytin',
          'Öğle: Zeytinyağlı salata + ızgara tavuk',
          'Akşam: Sebzeli et yemeği',
        ],
      ),
      BlogContentSection(
        heading: 'Dikkat Etmen Gerekenler',
        bullets: [
          'Ekmek, makarna, pirinç ve şekerli içecekler ketoyu bozar.',
          'Su tüketimini artırmak önemlidir.',
          'Tuz, magnezyum ve potasyum dengesi takip edilmelidir.',
          'Fazla protein ketozisi zorlaştırabilir.',
          'İlk günlerde halsizlik görülebilir.',
        ],
      ),
      BlogContentSection(
        heading: 'Önemli Not',
        paragraphs: [
          'Bu içerik yalnızca bilgilendirme amaçlıdır. Her bireyin metabolizması ve sağlık durumu farklıdır. Özel bir sağlık durumun varsa, ketojenik beslenmeye başlamadan önce doktor veya beslenme uzmanına danışman önerilir.',
        ],
      ),
    ],
  ),
  _BlogPost(
    title: 'Aralıklı Oruç',
    category: 'Aralıklı Oruç',
    description: 'Ne yediğinden çok ne zaman yediğine odaklanan beslenme modeli.',
    color: Color(0xFF6CA6C1),
    sections: [
      BlogContentSection(
        heading: 'Aralıklı Oruç Nedir?',
        paragraphs: [
          'Aralıklı oruç, ne yediğinden çok ne zaman yediğine odaklanan bir beslenme modelidir. Bu yöntemde gün, yemek yenilen ve yenilmeyen zaman dilimlerine ayrılır. En yaygın uygulamalardan biri 16:8 modelidir. Amaç; vücudun dinlenmesini sağlamak, insülin seviyelerini dengelemek ve yağ yakımını desteklemektir.',
        ],
      ),
      BlogContentSection(
        heading: 'Nasıl Uygulanır?',
        paragraphs: [
          'Aralıklı oruçta belirli saat aralıklarında beslenerek düzen kurman gerekir.',
        ],
        bullets: [
          '16:8 modeli: 16 saat açlık, 8 saat beslenme',
          'Açlık süresince su, şekersiz çay ve sade kahve tüketilebilir.',
          'Yemek saatlerinde protein, sağlıklı yağ ve lif dengesi kurulmalıdır.',
          'İlk öğün: Protein + yağ dengeli bir öğün',
          'Akşam: Sebze + protein ağırlıklı bir yemek',
        ],
      ),
      BlogContentSection(
        heading: 'Dikkat Etmen Gerekenler',
        bullets: [
          'Açlık sürecinde kalori almamaya dikkat et.',
          'Kontrolsüz yemek sistemi bozar.',
          'Su tüketimini artır.',
          'Uyku düzeni önemlidir.',
          'Yavaş başlamak daha sürdürülebilirdir.',
        ],
      ),
      BlogContentSection(
        heading: 'Önemli Not',
        paragraphs: [
          'Bu içerik yalnızca bilgilendirme amaçlıdır. Kronik rahatsızlığın, düzenli ilaç kullanımın veya özel bir beslenme ihtiyacın varsa aralıklı oruç uygulamadan önce uzman görüşü alınmalıdır.',
        ],
      ),
    ],
  ),
  _BlogPost(
    title: 'Akdeniz Tipi Beslenme',
    category: 'Akdeniz Tipi Beslenme',
    description: 'Doğal, işlenmemiş gıdalar ve sağlıklı yağlar üzerine kurulu model.',
    color: Color(0xFFE3A857),
    sections: [
      BlogContentSection(
        heading: 'Akdeniz Tipi Beslenme Nedir?',
        paragraphs: [
          'Akdeniz tipi beslenme, adını Akdeniz bölgesinde yaşayan toplumların geleneksel beslenme alışkanlıklarından alır. Bu model; doğal, işlenmemiş gıdalar, sağlıklı yağlar ve dengeli öğünler üzerine kuruludur. Kalp sağlığını desteklemesi, uzun ömürle ilişkilendirilmesi ve sürdürülebilir olmasıyla öne çıkar.',
        ],
      ),
      BlogContentSection(
        heading: 'Ne Yenir?',
        bullets: [
          'Ana yağ kaynağı: Zeytinyağı',
          'Protein: Balık, tavuk, baklagiller',
          'Sebze ve meyve: Günlük bol miktarda',
          'Tahıllar: Tam buğday, yulaf, bulgur',
          'Süt ürünleri: Yoğurt ve peynir',
          'Kahvaltı: Zeytin, peynir, tam buğday ekmeği',
          'Akşam: Izgara balık + salata',
        ],
      ),
      BlogContentSection(
        heading: 'Dikkat Etmen Gerekenler',
        bullets: [
          'İşlenmiş gıdalardan uzak dur.',
          'Kırmızı eti sınırlı tüket.',
          'Zeytinyağını ana yağ yap ama miktarı abartma.',
          'Mevsiminde beslen.',
          'Yavaş ve keyifle yemek de bu modelin parçasıdır.',
        ],
      ),
      BlogContentSection(
        heading: 'Önemli Not',
        paragraphs: [
          'Bu içerik yalnızca bilgilendirme amaçlıdır. Özel sağlık durumlarında beslenme modelini uygulamadan önce uzman görüşü alınmalıdır.',
        ],
      ),
    ],
  ),
  _BlogPost(
    title: 'Dukan Diyeti',
    category: 'Dukan Diyeti',
    description: 'Yüksek protein ve düşük karbonhidrat temelli aşamalı diyet modeli.',
    color: Color(0xFFB8A1D9),
    sections: [
      BlogContentSection(
        heading: 'Dukan Diyeti Nedir?',
        paragraphs: [
          'Dukan diyeti, yüksek protein ve düşük karbonhidrat temelli bir beslenme modelidir. Belirli aşamalardan oluşur ve her aşamada farklı beslenme kuralları uygulanır. Amaç hızlı kilo kaybı sağlamak ve sonrasında verilen kiloyu korumaktır.',
        ],
      ),
      BlogContentSection(
        heading: 'Nasıl Uygulanır?',
        bullets: [
          'Atak Evresi: Protein ağırlıklı beslenilir.',
          'Seyir Evresi: Protein + sebze eklenir.',
          'Güçlendirme Evresi: Kontrollü karbonhidrat eklenir.',
          'Koruma Evresi: Daha esnek ama kurallı düzen uygulanır.',
          'Kahvaltı: Yumurta + yoğurt',
          'Öğle: Izgara tavuk',
          'Akşam: Yağsız et',
        ],
      ),
      BlogContentSection(
        heading: 'Dikkat Etmen Gerekenler',
        bullets: [
          'Bol su iç.',
          'Lif eksikliğine dikkat et.',
          'Yulaf kepeği önemlidir.',
          'Aşamalar arası geçişe dikkat et.',
          'Sürdürülebilirlik zor olabilir.',
        ],
      ),
      BlogContentSection(
        heading: 'Önemli Not',
        paragraphs: [
          'Bu içerik yalnızca bilgilendirme amaçlıdır. Böbrek hastalığı, metabolik rahatsızlık veya düzenli ilaç kullanımında uzman görüşü alınmalıdır.',
        ],
      ),
    ],
  ),
  _BlogPost(
    title: 'Glutensiz Beslenme',
    category: 'Glutensiz Beslenme',
    description: 'Gluten içeren tahılların beslenmeden çıkarıldığı model.',
    color: Color(0xFFE07A5F),
    sections: [
      BlogContentSection(
        heading: 'Glutensiz Beslenme Nedir?',
        paragraphs: [
          'Glutensiz beslenme, buğday, arpa ve çavdar gibi tahıllarda bulunan gluten proteininin diyetten çıkarılması esasına dayanır. Özellikle çölyak hastalığı olan bireyler için tıbbi gerekliliktir.',
        ],
      ),
      BlogContentSection(
        heading: 'Ne Yenir?',
        bullets: [
          'Et, tavuk, balık ve yumurta',
          'Taze sebze ve meyveler',
          'Pirinç, mısır, karabuğday ve kinoa',
          'Mercimek, nohut ve fasulye',
          'Katkısız süt ürünleri',
        ],
      ),
      BlogContentSection(
        heading: 'Dikkat Etmen Gerekenler',
        bullets: [
          'Etiket okumayı alışkanlık haline getir.',
          'Çapraz bulaşa dikkat et.',
          'Soslar ve hazır ürünlerde gizli gluten olabilir.',
          'Dışarıda yemek yerken içeriği sor.',
          'Her glutensiz ürün sağlıklı değildir.',
        ],
      ),
      BlogContentSection(
        heading: 'Önemli Not',
        paragraphs: [
          'Bu içerik yalnızca bilgilendirme amaçlıdır. Çölyak hastalığı veya gluten hassasiyeti varsa doktor ve diyetisyen kontrolünde ilerlenmelidir.',
        ],
      ),
    ],
  ),
  _BlogPost(
    title: 'Vegan Beslenme',
    category: 'Vegan Beslenme',
    description: 'Hayvansal ürünlerin tüketilmediği bitki temelli beslenme modeli.',
    color: Color(0xFF81B29A),
    sections: [
      BlogContentSection(
        heading: 'Vegan Beslenme Nedir?',
        paragraphs: [
          'Vegan beslenme, hayvansal hiçbir ürünün tüketilmediği tamamen bitki temelli bir beslenme modelidir. Et, tavuk, balık, süt, yumurta ve bal gibi tüm hayvansal gıdalar çıkarılır.',
        ],
      ),
      BlogContentSection(
        heading: 'Ne Yenir?',
        bullets: [
          'Protein: Mercimek, nohut, fasulye, tofu',
          'Sebze ve meyveler',
          'Tahıllar: Yulaf, bulgur, kinoa',
          'Sağlıklı yağlar: Zeytinyağı, avokado, kuruyemiş',
          'Bitkisel sütler',
        ],
      ),
      BlogContentSection(
        heading: 'Dikkat Etmen Gerekenler',
        bullets: [
          'B12 vitamini takip edilmelidir.',
          'Protein dengesi önemlidir.',
          'Demir ve omega-3 alımı takip edilmelidir.',
          'Hazır vegan ürünlere dikkat edilmelidir.',
          'Tek tip beslenmeden kaçınılmalıdır.',
        ],
      ),
      BlogContentSection(
        heading: 'Önemli Not',
        paragraphs: [
          'Bu içerik yalnızca bilgilendirme amaçlıdır. Vegan beslenme doğru planlanmadığında eksikliklere yol açabilir; uzun vadede uzman desteği önerilir.',
        ],
      ),
    ],
  ),
  _BlogPost(
    title: 'Vejetaryen Beslenme',
    category: 'Vejetaryen Beslenme',
    description: 'Et ve et ürünlerinin tüketilmediği daha esnek beslenme modeli.',
    color: Color(0xFFF2CC8F),
    sections: [
      BlogContentSection(
        heading: 'Vejetaryen Beslenme Nedir?',
        paragraphs: [
          'Vejetaryen beslenme, et ve et ürünlerinin tüketilmediği; ancak bazı türlerinde süt ve yumurta gibi hayvansal ürünlerin yer alabildiği bir beslenme modelidir. Veganlıktan daha esnek bir yapıya sahiptir.',
        ],
      ),
      BlogContentSection(
        heading: 'Ne Yenir?',
        bullets: [
          'Yumurta, süt, yoğurt, peynir',
          'Mercimek, nohut, fasulye',
          'Sebze ve meyveler',
          'Yulaf, bulgur, tam buğday, pirinç',
          'Zeytinyağı, avokado ve kuruyemişler',
        ],
      ),
      BlogContentSection(
        heading: 'Dikkat Etmen Gerekenler',
        bullets: [
          'Protein çeşitliliğine dikkat et.',
          'Demir ve B12 takibi önemlidir.',
          'Sadece makarna-ekmek ağırlıklı beslenme hatalıdır.',
          'Sebze, protein ve yağ dengesi kurulmalıdır.',
          'Hangi vejetaryen türünün uygulandığı net olmalıdır.',
        ],
      ),
      BlogContentSection(
        heading: 'Önemli Not',
        paragraphs: [
          'Bu içerik yalnızca bilgilendirme amaçlıdır. Vejetaryen beslenme doğru planlanmadığında eksikliklere yol açabilir; uzun vadede uzman desteği önerilir.',
        ],
      ),
    ],
  ),
  _BlogPost(
    title: 'Pesketaryen Beslenme',
    category: 'Pesketaryen Beslenme',
    description: 'Bitki ağırlıklı beslenmeye balık ve deniz ürünlerinin eklendiği model.',
    color: Color(0xFF5DADEC),
    sections: [
      BlogContentSection(
        heading: 'Pesketaryen Beslenme Nedir?',
        paragraphs: [
          'Pesketaryen beslenme, kırmızı et ve tavuk tüketmeden; ancak balık ve deniz ürünlerinin dahil olduğu bir beslenme modelidir. Temelde vejetaryen beslenmeye benzer, fakat balık tüketimine izin verir.',
        ],
      ),
      BlogContentSection(
        heading: 'Ne Yenir?',
        bullets: [
          'Balık ve deniz ürünleri',
          'Yumurta ve süt ürünleri',
          'Mercimek ve nohut',
          'Sebze ve meyveler',
          'Tam tahıllar ve sağlıklı yağlar',
        ],
      ),
      BlogContentSection(
        heading: 'Dikkat Etmen Gerekenler',
        bullets: [
          'Ağır metal riski düşük balık türleri tercih edilmelidir.',
          'Kızartma yerine ızgara veya fırın tercih edilmelidir.',
          'Haftada 2-3 kez balık tüketilebilir.',
          'Sebze ve lif dengesi korunmalıdır.',
          'Deniz ürünlerinde tazelik önemlidir.',
        ],
      ),
      BlogContentSection(
        heading: 'Önemli Not',
        paragraphs: [
          'Bu içerik yalnızca bilgilendirme amaçlıdır. Alerji, özel diyet gereksinimi veya sağlık sorunu varsa uzman görüşü alınmalıdır.',
        ],
      ),
    ],
  ),
  _BlogPost(
    title: 'Alkali Diyeti',
    category: 'Alkali Diyeti',
    description: 'Sebze ağırlıklı, doğal ve işlenmemiş gıdalara odaklanan model.',
    color: Color(0xFF9BC53D),
    sections: [
      BlogContentSection(
        heading: 'Alkali Beslenme Nedir?',
        paragraphs: [
          'Alkali beslenme, vücudun asit-baz dengesini korumayı hedefleyen bir beslenme modelidir. Bu yaklaşıma göre bazı besinler asit, bazıları ise alkali etki oluşturur. Amaç daha çok sebze, meyve ve bitki bazlı gıdalarla denge kurmaktır.',
        ],
      ),
      BlogContentSection(
        heading: 'Ne Yenir?',
        bullets: [
          'Ispanak, brokoli, salatalık ve kabak',
          'Limon, avokado, elma, muz ve armut',
          'Badem, chia ve keten tohumu',
          'Mercimek ve nohut',
          'Sebze yemeği ve yeşil salatalar',
        ],
      ),
      BlogContentSection(
        heading: 'Dikkat Etmen Gerekenler',
        bullets: [
          'Aşırı kısıtlamadan kaçın.',
          'Su tüketimini artır.',
          'İşlenmiş gıdalardan uzak dur.',
          'Tek tip beslenme uzun vadede sorun yaratabilir.',
          'Bilimsel yaklaşımı göz ardı etme.',
        ],
      ),
      BlogContentSection(
        heading: 'Önemli Not',
        paragraphs: [
          'Bu içerik yalnızca bilgilendirme amaçlıdır. Alkali beslenme tüm sağlık sorunlarını çözen bir yöntem değildir; sağlık durumuna göre uzman görüşü alınmalıdır.',
        ],
      ),
    ],
  ),
];
