use strict;
use warnings;
use Test::More;
use Crypt::Mode::CBC;

my @tests;

# test vectors from http://csrc.nist.gov/publications/nistpubs/800-38a/sp800-38a.pdf
push @tests, 
  { padding=>'none', key=>'2b7e151628aed2a6abf7158809cf4f3c', iv=>'000102030405060708090a0b0c0d0e0f', pt=>'6bc1bee22e409f96e93d7e117393172aae2d8a571e03ac9c9eb76fac45af8e5130c81c46a35ce411e5fbc1191a0a52eff69f2445df4f9b17ad2b417be66c3710', ct=>'7649abac8119b246cee98e9b12e9197d5086cb9b507219ee95db113a917678b273bed6b8e3c1743b7116e69e222295163ff1caa1681fac09120eca307586e1a7' },
  { padding=>'none', key=>'8e73b0f7da0e6452c810f32b809079e562f8ead2522c6b7b', iv=>'000102030405060708090a0b0c0d0e0f', pt=>'6bc1bee22e409f96e93d7e117393172aae2d8a571e03ac9c9eb76fac45af8e5130c81c46a35ce411e5fbc1191a0a52eff69f2445df4f9b17ad2b417be66c3710', ct=>'4f021db243bc633d7178183a9fa071e8b4d9ada9ad7dedf4e5e738763f69145a571b242012fb7ae07fa9baac3df102e008b0e27988598881d920a9e64f5615cd' },
  { padding=>'none', key=>'603deb1015ca71be2b73aef0857d77811f352c073b6108d72d9810a30914dff4', iv=>'000102030405060708090a0b0c0d0e0f', pt=>'6bc1bee22e409f96e93d7e117393172aae2d8a571e03ac9c9eb76fac45af8e5130c81c46a35ce411e5fbc1191a0a52eff69f2445df4f9b17ad2b417be66c3710', ct=>'f58c4c04d6e5f1ba779eabfb5f7bfbd69cfc4e967edb808d679f777bc6702c7d39f23369a9d9bacfa530e26304231461b2eb05e2c39be9fcda6c19078c6a9d1b' },
;  

# test vectors produced by Crypt::CBC
push @tests, 
  { mode=>'AES+Crypt::CBC', padding=>'standard', len=>45,  key=>'4cdc909dc310796429e26bcaca1b21329f5060813b7d17bf1a65f293154b54a9',  iv=>'9124d8cfafd3d732e597f463d35a8a43',  pt=>'ad67301bcd23a5d7b4601f93db3e6b5db71243fa00244182d0a2df6f0384a09f117821b7b70a4bcdc0a73a70130851f704a7aca59b96a3e5b8dc89efa7ee7846a906a3eb591bf8b6b472ae07113ac3cccfb1bc84723ed1472c1f59705eae7b9fbd6df2b38d2eac2a6c726b9f92',  ct=>'588c33d96d99477bc6305c829a1fb188ab165f60ccadac67daaefb8054cfe8093cbb6fba14b684c26cd10c66db87cf1aa8cd69c98180d1d7cb6edc9191332863653ea707cb9ec4da0c7d4381cac33faa938a53df3519d06859260be7ac582674cdedfa411f4cd0204c8b2132d4b100cc' },
  { mode=>'AES+Crypt::CBC', padding=>'standard', len=>46,  key=>'0c1afd6567e265240aacef873eb78ff11ce0e53931ca7de49143d8a2b1c84df5',  iv=>'df5f1521ed1ee7b47ae7e5ef0ac49abb',  pt=>'13436402bb6c57b3f202e88cd4d21d828e85856415000e5ef01f9fe43bf100ee5b94ea29e3246200dcddbc5779dce5e219c078bbad8cd878727c0c27f179c100beefcc832f605c8e8f27251a8b51b2475d5170ff8100c95d4d875d386016535a13373f7e15d798e0c39c94193b24',  ct=>'3eb5203a12d11b2fe629cd764a9963ad7f314d0efe75806c12e00f3bfe916c765a318be81337d1cb43f20c030f8af6e31991fb09477d06baa3492836f884470177584ad32241ac8fd66469fdd858ce1d04e90375689e70a4bc40be149b1df6cabc5943cff8e7cecdac6fe81fc0aac8f8' },
  { mode=>'AES+Crypt::CBC', padding=>'standard', len=>47,  key=>'9dd6b591b1589ff6fb5bbd41a8da4b1449674155119285857d719d44281daa3d',  iv=>'321d48c36326dcc951aa208542d2fdd7',  pt=>'75e4309485e3df2006c411a316073973e8adf51bfd6287a7833f15e18f2f6b571c192a527bd6290722713eb77c9116a28b321cc5decd44a5a49a13750d43e99e4d360e647300cb7b9d31a82c39d8885e6d2b5521f1c7339b30d3947bddc7323a50891f4d37a7bc9cc6971037373722',  ct=>'f1f7d95a90ece772a931e3c1f919da110246268291d10d5b2a3ff62596f0cd2a0c3dbdab41e210424f5a1d35b72a4df26a32d4c9ac80e808438f31e07a4f16555a82bade488a73afe239e6c557f100cf17632a8f767445ad6db8f7d2775f63f4b4e73fc5180b20334f941f8c49f7968a' },
  { mode=>'AES+Crypt::CBC', padding=>'standard', len=>48,  key=>'d2ee6699d1c975c08c08644d0c87cae26da0cf62a32e722926dcef82d4076e93',  iv=>'a6352c34af3450612cc9070e686fe37b',  pt=>'20f8ebe4281ed99f7fbacf781430e6ac89c984acfca73073efc168109690e0027f3f9954c2aaaec8fada73d09a2715c9ea33224d9360ca8fc4b379a656fd9ac9be49196cb2984387caff89f48c40cd8393f6bc13e96b37f1ebcdae167c05b4ec1a46bd1ed31cf1f5ee89415dac1782a2',  ct=>'17b300b588ef03a585c8130c87e1247d0c7900bd2f31f0a0eab4a542e370e9d6ba5ea803aa48bd67f2e23da3d6761b97ed32f313baa2e65c23b344605eb740a7d1e4cf26c320c2830e387e8562361eb0900868bf58b5071fd54c449ab15368b9940ac507761a0e3ee3ea37287de6e476adfe344d00c5fd4a8d008f4f4bc70b26' },
  { mode=>'AES+Crypt::CBC', padding=>'standard', len=>49,  key=>'e48000f92e643c1821a307fb1673ecdaa834b423ad4e45bb922ab28d97213116',  iv=>'85a3a0c660f7bc183383516143d6102e',  pt=>'099b427090a4d806fe9a463872aced748ef4e1747be7063c7ae5b0738cc3247f170a09460236964540b533fc271fdf9bafb9cb0c3e408a59539ee8b882890bf9ff826e1c568ffdad503f0d5d7568fb4aae6de43c75b541fa7b08b32ba8fa18cc8ffd5a97206ea2ec5fc7f3db542f9c496e',  ct=>'59ec204ea6a862236405a97d89b9bf1692c4694a5aea039fd08e3a6ed35bd5764a8cca5cffb3bf5913d0b5d4f362f4f171f72240a91878b3803ea41a14a3d0b80771eb446971f682069d7e5c5d950c20d14011bee512f786972f0fd71db631f7332cd863d1285ec994418db47b7204c7148710c6dde320f614c621c6ae819095' },
  { mode=>'AES+Crypt::CBC', padding=>'standard', len=>50,  key=>'410662fb7ced9a775632da209b8c1d114de85ee83739850449650e69b082f261',  iv=>'7e98386b58bc8a85af4b8b3c7c9ccf48',  pt=>'77a4117d8ccd4798bd32c7079b64aa04f0ce964818c897e6501b2dc115155018a32584c17014f4b87b98983ff7ebc46a6a971c506d966e2ba190fed03a8f771e003bb940130650acfafc705185f4905e8c05a33a8f5114bbfc17c7817afa5bcb8395c395ab3c365bdcc7e7b80e69a0730029',  ct=>'79ba74b32dbf1d84afaee3c577e9f28cb1e38ce0e39d8d9938e54d17acb2d3bdf811a776aa8e92aeee579657f2c3430d67afc2b3e15c26f6eff2a483df219b4f72367a75827986e001264729ce7e82c32df66dede60d3105f7debc0043539b797fbc63ed01879a2c2ab96861411fc4757908eee0754df56fccf4cabccc76538d' },
  { mode=>'AES+Crypt::CBC', padding=>'standard', len=>61,  key=>'e6e52745bec4be4699cb1fb15797d4c6a211942a3405c1c9ddca549f3fe882c3',  iv=>'4f86433e92beb35ef6d56f1d14928669',  pt=>'cfb9ad9bc13efaadd46ad46ae09413e7e30707cee0f90e263b86469f48d691babf20a685988a58592b9cee19ba15db8a75fac948d77e834184108496aab2bcc3a3e55e2246a0f32568fb27782c54661d4872bd6300a379d09ac30911eee5ac55f476137dcb6c5a5b2d7e7268f7e8e62f1469ae5c65378a75a407cf9a8f',  ct=>'0d817303f1b9d1bff93aa9cdb89abcccfff4bb630695a6275b330975bb0f58f8350cd791a7634b0c7973c3e2a142bb1d215c1e9e083424c0983b546d13fa4017ed7b726702353d54431b276190c6ee404b9a3032234b8303a2653588c4ef2f931db9f9c3e1895ad68bf60eab45a03f63d165754fc055c571c80a9bb6919e9a36' },
  { mode=>'AES+Crypt::CBC', padding=>'standard', len=>62,  key=>'b9dffb9c4ba930ecd69e4c19530705c70bd95f5dee943d0b15f382dc11a6c2f7',  iv=>'295907c65d22d55743047215e43ba578',  pt=>'13de19bb521bbedb2d88588eae8898b3fad2f264173b13605afe9e932b606a9f6f46b2f6499338efe48b6723869524e9fd5bf5036601191210fc91f54ef064ed437df8be1c1d4441db3736ee61a67a107206f2407ed48a494103905eb1c3f3a7cc3146c21d98d1e0538943c88be8d5074d87afd97d5cdd3631d1783c08dc',  ct=>'cf55d9e1eac7414684a2a1c591a6a7be855771fb293e19197c3a3692dffafdc524550501e04461f87b721d18e2a4f27bd74a13d0890cfc39655c176e74fa752e51a9d39e25baf65447200611ca6e6c482ae0d042692180d6ee91b900b845cf257c7252b357f23809e9b8b4cfc0fb004085b0b61edcb747eea9889c1081456c5d' },
  { mode=>'AES+Crypt::CBC', padding=>'standard', len=>63,  key=>'cf2b183e93b2b715d8ef2424c09b24d1eb9cb3bfa6c4b5ef365526f4a08d7b9e',  iv=>'e61ba23a2c70f999dee235fd30bdc3dd',  pt=>'59a76d9394d5e16fe3ba53897295ca1fbc898119ff500f9fd3a8fe823116159384f8d60dc65a5a97aabecc497819d6aea306f4b246a76e62133ef98ca7829b450b247cc4f78ddc8d429474986fa03ab404b05b661410feac9bb39a4510a479fa3fe4f34f86c0812bcba493671e98f6a973d0eaa04fec13e98ac60bf07dc48f',  ct=>'6ecc1fc3a67f17b9791946a3c3434bb441a9f30eba5efb1d3173eb71a5a0f98d3925addcac29d1ad69f7bf19f56d5b73e984ca4b7686d66674f1ce0b557cbfaec542dd9c4f3f7ca4dbf99a7e391bb6eca127661468dd71b72d030e51bef89f5326b71ce08760f3455f61bafb581a74ddb100778899ba97630cdc376a7d08c6d8' },
  { mode=>'AES+Crypt::CBC', padding=>'standard', len=>64,  key=>'f5fa281cf55a77e3a45388e6d64c616a2b26f47af51cf2ae21eef483113f704e',  iv=>'b22052aae87626bfc7b67af9c3b959d6',  pt=>'5fdf2493e809ea6ec9179a2235dca09725259d58cf87fb2cf8765c1e7171b346aa3dc4ea5885c1a6a8377363ac283af15b6471c8b4d57d38501c587448608f8e69d06ac533f4da6eeb4db3a19dad66de07165c36e953261a3db7e95c35300afcc341253a7746262e3ee811e9eefc3dc72f0c6d629baff9d804ee1ebb0bf507fb',  ct=>'abba44e77469c68db93419e041aa512a47aa03891e102182668591614bb81d083a6c6b9ec761aacb65e7a6456e2a602b10f86cac6c886ebe84ac5047ea8a9ed5f6134bdac936c3e3cb5a21275ac471f24c02a31be7f1088bc1d0d798310a180596f8d4632ee976bff4f80d227a31992830028b1112d9c46f3ac88e89992088bb9c7bab2d9c1e403ec98102007feffbee' },
  { mode=>'AES+Crypt::CBC', padding=>'standard', len=>65,  key=>'c4c2d3a2aac2db867ff91cd363050da166af579f18f24cac74dcfe5f0b283b64',  iv=>'d5be581e0bee9a6ad46d6a9d1a454f49',  pt=>'1ba72c2c58b536c3d88b0f67c99b8ca4aea8956c5e78f4527521f2a9017e6a392b2d7a82c8086a646ea78d64a06477fcf8e38ce4d75cfc6e0c60b3b9d4d23bbccfc5137c86e5d80c01139fb43907a99152b6bf9392242cdd0840e838e39cd1c121260e8f2f5ce11d2dceb7d784eba1964c427b949069b6b412a8cc4b63fe0493d7',  ct=>'a3026f2b0151760da3bf7ef194bad524fc74aa8785dd3f2b8ed51702e39590b97bbc9d68a1156c8ca73a8bb222f4d5e9f5e0319c1f67f774cdcf8afb5acd58629e193b251dd122578a09b5a83f5d6fe3e60348ef8da5c3300b98065bd264071cde25c4ae67dbb393a66b3e190c7d79b4a46a8efa1aa263816e56956c2e4c261c0f32c5828829fbdfcf3e81cc1813629f' },
  { mode=>'AES+Crypt::CBC', padding=>'standard', len=>66,  key=>'6ed4b7d127dce8bb15d6d772e043e5f4297d0c936671572823db00346fe8c54f',  iv=>'c148a482405a6adc4aa7bd55d4fb9c5b',  pt=>'982cd450603380b0001449817ea73efed17581846178e308e8e732e4001a7843fbfdc9e1c1b3f136e01008225c67d3be503adf82795257754c0b1e02d8415da82b8cb47e537f9c6f9c21571c52eab3c7fcc91a94e9b4fca0b5f032d302ef8c592cc54647ff1f58ede5001b6a65f28a00029519b38801843cfe9c63f088ec575cecf2',  ct=>'4731d8fc61ea27f54595314239b0c6ea9708dc8044950725e0814e47d4bcee32fc88b1734933688e3df66479f74d47000cb88d19d40c01415db4abe1c2008196c7cee60c173943d9360fcea6b05fae17ead1e879f4f8bc4e085c73732dc2c5f9aed46c6d3dc63354d1b7d08f4fff00eed533889e895a5897fef338185deee24ccd225713b4a3e4cb3db6e949dd83f0a0' },
  { mode=>'AES+Crypt::CBC', padding=>'oneandzeroes', len=>45,  key=>'a31400af9c12b62e9f512585e2096ca5c4eb3f3d0ab3fab82c651b59d92259bb',  iv=>'9e6e3e7eab26dffb2d1f0a94cd6b40be',  pt=>'5da888bd7a8e29568c9a05f6f6935439b6effdea9e862f775116bfebdb4fbf489e0d82a79e82e0c0912bd5228c1adc84a51dc0f2ba83c4c68edf2709569eef8a11b3c99da949cccbe2a843cf9d20d1d1ba1df67c085c61518fb16c44aa9b05034b49bcbb9b010fe84dfa111ebf',  ct=>'ed5fdc33568ffe9bce4a7cf15fb0f4a11e644c6b9a349b39968fffaf1dfa371bcdc53a7bf2f642ee629ebdcd9e37f4b07994b5184960c7600a54cc6f8fedb0b85292f0a72343bd3aa838f04ba9d6dcbb947fa21e94709b652da239b13a5a5cc828cbf186d35c717e41319d0fa57ba627' },
  { mode=>'AES+Crypt::CBC', padding=>'oneandzeroes', len=>46,  key=>'cac6d61e5acf7d818db0d1344cdbcd34a9d5f699a769898e474e7475ef99ca80',  iv=>'c65d55b06f6ca01b0a197159a901e2aa',  pt=>'e52274e59b046d5bf01dca1ef6e3afeb289f7fe256c857367ad4c7382d219973cc00697cced4563e1569ee91f21c3703f7ea693df3d4f0814c6a2563294b1182cc26f80f7ea5dbe6b2e2e2780e8b7a205fb7030462e9daebcf0db58c96a6cbd7a2219a3823a712a52ff881b8e74c',  ct=>'7611509b6df3dd00da0c84b320a3a2622318b533724170564ea83d3099d564ac995c4ad26900d7846b40c02d477b5a5c2171950aba4b082e7aaa2a51bc57c8fdd94350bb5975538113bda892074cadfcd1d824c585245790b0b281910ab3f0b19b05bf7752cfeedc10d55750c098c1d7' },
  { mode=>'AES+Crypt::CBC', padding=>'oneandzeroes', len=>47,  key=>'4102b812a1ac0a8cc224c9f48372e6b5f51ef5240f9021042207c32e311c6dcb',  iv=>'6294d27e3b6a1bdcc9f9e542a74dee06',  pt=>'46c6c5ca20642b5c4a380acdd20dbc7f1c0bb60024fa6b6654cb43ed94f4ddfec2edeb30acd31db015cda268e872b0f4802cb779dadf027372b7c409ae58ddc2a93f5a520d958b3503bb6c53c2ec95e02b0bce79888d7bf45bab21857ac959b6f83aedf88e982ef2e8d842232e77b2',  ct=>'4f0ba8ccc9a638aaee103a9eab8055166259a73f67615751a26be2d9d00674b29d8d22c7667eabe48c6176f946c198a78393e342ce69bd1fce05bbb3c0d5ddc8c8402a7e6e56dbca37d27c2fc28e97c0010d706ff4b6a76172b383f31bcd344e092e2c1a4feef23a3b719ae250af69fe' },
  { mode=>'AES+Crypt::CBC', padding=>'oneandzeroes', len=>48,  key=>'18b9e2cd23bb350cb9e1c3260339d991d76640c85d492157c7d9b9fd2551fce6',  iv=>'2952a3e126418b7b889ae54c7f93c214',  pt=>'4190805d7ba4c03e19887e5e501bb6ffd7345d0fab61a8a7b3b62e3a58de51937bc3f4550b8b35d60ef65b08156618ba455c9f10872aefa1ee9b3a402b2da0523dc46859246cf233dc7f93316a2624b7cb8c7eae1cbeddb8db14238d0856b38d95e8f44bf225bdb0493808c145334b28',  ct=>'94e533ad2771dd88c76d38cfc32497a72e603efbf73b8cd128296415da4e0376e551f2c583c9bf91c539204ae54a47898d041bd0f7cca9a6f7fda1890ea4cc9c68335db83dc54507d947af3e7c12d9bbc98d8d0576c506ae4a3ab35bd4605710b924068b24fb1e32ee826c2d9562d0d1a551050909b3598eb2bdb9811a1cbdaf' },
  { mode=>'AES+Crypt::CBC', padding=>'oneandzeroes', len=>49,  key=>'6cb5798c1009611d7231c872d5f98195b4a232e626e636d746e714e336926d09',  iv=>'21bd28feac672984d5eff2db1df1c55e',  pt=>'e8d66e82828e539419a337c6430c9f3cb1692a1d2e8a2d98d9f14b31bbdf259539890be5d55209d7101fa11dc566960800517727a90cf97d5984364c12bec9f7a88b9375f7341681544fcb8fff9ccf791e6e1541035f8497d3a301e224ce649fa4aafe7ba21a49bc94ed376a745fccafe2',  ct=>'62ea3d115bad96e4980c12edfb4e5da2d53c57e15d50bc2ebc9c24401e8a94ae0d3e90dd6fa08a83a405d9b5a8323ec8a169da63c0c600122122a180cdd52470583b0aa80c91d677e7a6e0b25e61cb2cb4020c384b2bab68b53c35d2cfe5305dba2bf61e1d273b9237dbed4400a40d90b90170c1180171f41f5d71a9e3b37910' },
  { mode=>'AES+Crypt::CBC', padding=>'oneandzeroes', len=>50,  key=>'728757dea0973aa1f5a69c859f223c22d4ce91c3817011c252ea033aeea4da21',  iv=>'a1ea0246ed15c43bfd4502ddb586ae89',  pt=>'647dd99c0065d239e75737a794f079d912e6464dcacef0dbbad08211d123dc7f64e67f6bceb01e6f82c6c6415fbaf2f1065d1c2918c32422dee54a5c3aeea1ef54fe7ea3c51adfdce5f09d7a693988bd85f46f99631647655346df80d5f775db9e2db472124f3c2fde92ab73064fedc8c776',  ct=>'294c695e58bf34e2ade1b8140eda57918cd4e1fc0158745498778cc0e2b88dd068285b994e1206952da749547dc6d0080cfc4c41e0b4e4c944d85c19115b1778abc384e0a565af8fd7999216d423eb6040a02322a82f9f40bbcc43167a6c5115c8629124e47c429980845dae04771d1c20475027cb54da48048b8f06b7cf2113' },
  { mode=>'AES+Crypt::CBC', padding=>'oneandzeroes', len=>61,  key=>'5aeedd3c1d2ecc0fc0e951337d8a61abeae3e6a89e47b57b3bb10fabc4a6299d',  iv=>'a6a6fde7cd96880499a1922e04222e71',  pt=>'19cff45762e6bdfc55b0d3efdb22734bebd426c71f64bbf48448bf0faf762c498313ed15fed19036226a977805e8fe43f51ab81b1cce787a42b666d4bca64bfb59f225e68e6eb54c6e47c879bede3c2896cb2e6be4e990eabcc266e4e5561ac028299947a5a2cafda352abaab27e1c4ab6b40c25306acf3c43b3084a3c',  ct=>'9d6d671e1f81aad8906559135c5a9af3c1e277675cb80f9cb0ca7ac033b041beeb2d86fafc7af7041900a619f4b821a5a0c7a87c6b9e0909f74d19b631b4754c642db425ddc1accb596fcdfc7d5f6774b1b867085649dbdc60783726568ec76cb21933ac5d374b29ed02d70e285b769fa0b8de701308795e4d01219f83c8a6f5' },
  { mode=>'AES+Crypt::CBC', padding=>'oneandzeroes', len=>62,  key=>'2d17ff1612873c72f9f7a98766f287ae6721b369024fda2b8a666a6c7f0a0ed1',  iv=>'fda61ecb9f3d0e097d901f83224f23a0',  pt=>'bc1d4c335a2d466eea4b540d3eca5083649a375ec125881e6217fd317c5c98cb85f7116f43b37171dad7d3193dc3a6839e5136ac3fc10792e5f9202880976a5b04f8c14149129b5d97b7cad9daa1863d5ebd14f8a45669b3b4458e27aa8bc2efbe1b215685646ec6e4f52c678b469043cbbf8e299d68c4e3e521b469ddc0',  ct=>'ebb5ada37eeb7aa60f2eb8f26dc589cf8d92e98cbd2ceef65f057c6dcb9cafd3a05b5ace7a483f8630b1039e62161774f3baa0d439bb3c1583e83bbc953e278f80230f4147cbfcabc7320b81d265115323708b649667fd39534fdb43ae081ea2f834c74eb44b8e6f72710bd84fcd8da48a596611268f278b8508f195fc40af3d' },
  { mode=>'AES+Crypt::CBC', padding=>'oneandzeroes', len=>63,  key=>'059d905aedbed8a3e83ea4e78bb1f83cfb8abbf4d8b59cd377c2c8d21804e172',  iv=>'515a7f90bbfc534db5a9d73c0f43b665',  pt=>'9eab0ebda29a926352ecf3a845cbba7e1259a2dd6cc1d090849267134c802c966027bab6f4ca1f1156157bd5584a00496bd0d3802b1af1647b7759c021fcd08af956696320ed2a5f673a1c91862ea49c8bd48f94e78b79a575cb46483cd4b343c868b0ae136d84814343348be1ee3f851aa06afe52fbf296d30a49983e2c00',  ct=>'ef8a589776965e0674c135245a4a2ac7a783b4faee906372616f0e63df396faeb932fa0c68aa023107c91bafbca02cac55233eb9df61a042fb745d52a835833e34ffc1cb4f7239d1b9f14988239fc1fa621db6dcbb604154a09c578e3f617193458b0568cf6dd1533bb5c38897f668dfd39989acbdec2c0d8cd61d27ba770b28' },
  { mode=>'AES+Crypt::CBC', padding=>'oneandzeroes', len=>64,  key=>'89d796ce74233ee7928ab3530c130c847791a5a841daf9aabd569f435796a54a',  iv=>'758178be5d320fd5bf0e7c6b99b71b64',  pt=>'dbd5aef963e811f4abe1e7674b1454f0f27e583b33b8f5097c6d8073a82a2a03473e451016a3646a6f9e78f7a29b8429c15c9aa99b393350219eea0fa2af830ab83686fb85c46694b1a6c2296ebcfc4288b02aef5e57a4ad6eef67e0805580bd9592b7570d04b19180949804bf90408c5ef2d99ad8dec1c302a9180369855510',  ct=>'50104d3952006fff50bff50108b7eee2ee6e95fb7f0d4bfd8285871eda133836bc929f3c91fbde7e9be69b566ead6b4ae3717040c2422442d6e33a0d226d1da8fecc2f4a82e10e87d426b5608136c09878b116a8a20b3064b6b2ca20e4ff4beba7f35a3e1bb9a6b46b3bad912f8fed6545b9be30f5540182dcf5246535b3f511d087e9a91862e36e26ec44b20097ac80' },
  { mode=>'AES+Crypt::CBC', padding=>'oneandzeroes', len=>65,  key=>'65ce85da260bd2a0779ee905791ecdee4b6f310236b137488360945efdce39ee',  iv=>'2c9235dde136a62b9a42b32485970f25',  pt=>'4871a0e74c3a510a9488f1f3404e5e76c76620e5e54d31e2359bc757867a559aee04c1c57618fcf94647f0262539e463591c8c6ac69f8458aa94da87835ec94e60a4b8bfe33f5d39194dc59ac5cfab8caad66f82c6934894bc2d9bda6132c5d17aad599dad9b5385754928907870dc32d415d663b626178e0a8fee5159530ec6da',  ct=>'4b311dc4a84f173747e730aae501e548e152f48151c49ebe2e2369799db22aed0bc6927527145c87afd359017c796a987434b1f005c2ed72a7a012c17d7b4f179897837e432fa3615350006001c61744ea860df63f9081d5c2e7e2c24f43f8908651dbc1fad594ef749e8ad2484cd92040a2c77157a835be6cbf0674bb78a12cddb6040ebedeeed148f072c978fb5be9' },
  { mode=>'AES+Crypt::CBC', padding=>'oneandzeroes', len=>66,  key=>'259dcc1e8bd959a66a58b5795768e341579db530a823ebff38e46b51720fb598',  iv=>'11bfb017d9ca4690b0fc7ee6199eb20c',  pt=>'6cf1d98a58b5683e403ea6747a02b2b6b3697114a5d8234f63637cf7327c8df19eafc185710d53ff762de59babc66ae3d5697ca7dd38ea00bebb741434dd7d8dab52b9876c9c4cefdd36c6b0c716108273f7d3d23f7970990f09f9530276236489b64a0079347cb14eb82106fc2945a40553392f3d964b677870fe6aeeebf159eba6',  ct=>'ff829a0e6e21de39a5a3733a7f6d4b52e8a72e97a7192afeaa29c63c12bc57b61f5ab04b3cde81d557ad57f5c1771b24ededea0f2a7a3819d9d463f5c195503c145283c762ba6adf876fae4efb8b22c24a036b6d27f4d65c6c9db5d584e504af2afc6e932b67f24e07fae51c6e14a981aec4fac5161a523e944529bdeba100a3b366d5c6a730a7e9382a7a824d31c463' },
  { mode=>'AES+Crypt::CBC', padding=>'none', len=>48,  key=>'5e6a5e40f836575205cd7db38f7ca96624040450317770e8a3c0516802bf7135',  iv=>'61ad18d56036a51d9748f291ec007df9',  pt=>'975123a7b4d97d11e562b9c47bbdc55c19398512d2ba3890123024d7066e66f94f5c16241695785b1fc11f3191bcd7ac7b400ca6c633ae73dfb0f4e97669ff724366f147b3333182117e02dd5469732677bb29c5d9d15e9019b428663287948307706f88eb0392acdda2c0e36d6b3c15',  ct=>'7a7e50b6650920a3447aefd5a0e54389499d919f3eacfacdc6593febccc15c5f5d9a1a1036d7ac0e3b03026aade4e88c2cca310725314add54df3dd2e68f6687ac54644075261bdb5e8dd474191714d7e90a5b71307e0011e98e2b73b8c3b53f9e698e851e4a7b527f0e3c3a3781c598' },
  { mode=>'AES+Crypt::CBC', padding=>'none', len=>64,  key=>'d0f6307a64837231f7ef94a8100fab507e31eb180a4b0f514f4128f431b19d92',  iv=>'53095c611e2172debd73a7780ab8fd6e',  pt=>'da7a390b0b83b4c7f054a09d382876135997bb00d73f59bc36c1d1d7943d241c4fc91f670978e0144d1ffe1dac6d80989b35518642ffa1a854fdb4d6aedab71a97b64cedadafff46476d97830bbd9f8a9ef16381ee59f1e504e6284ff1b4328bc494e55acbf15f61c644611ac24acd770ed984318ec151fd9637b1cd0e67f570',  ct=>'a653d2ef928cf109351a01953cd53795fb7baf9e22e6863c3df0a384ab1b13a53777f881a60e10d192a88e0db2066ad85accfa438de56b4c191cf2ec69bdf89744b7f0bd6b466912fcebbdeea53bd957c42396bf983f0633df91109e790b598099d6c1604aacb11e03135c30953ec9b23f2d14cdaac46ef56eedbdedff5596c7' },
;

for (@tests) {
  my ($pt, $ct, $m);
  $m = 0 if $_->{padding} eq 'none';
  $m = 1 if $_->{padding} eq 'standard';
  $m = 2 if $_->{padding} eq 'oneandzeroes';
  die "invalid padding" unless defined $m;
  $ct = Crypt::Mode::CBC->new('AES', $m)->encrypt(pack("H*",$_->{pt}), pack("H*",$_->{key}), pack("H*",$_->{iv}));
  $pt = Crypt::Mode::CBC->new('AES', $m)->decrypt(pack("H*",$_->{ct}), pack("H*",$_->{key}), pack("H*",$_->{iv}));
  ok($ct, "cipher text");
  ok($pt, "plain text");
  is(unpack("H*",$ct), $_->{ct}, 'cipher text match');
  is(unpack("H*",$pt), $_->{pt}, 'plain text match');
}

{
  my @t = (
    { padding=>2, key=>'259dcc1e8bd959a66a58b5795768e341579db530a823ebff38e46b51720fb598', iv=>'11bfb017d9ca4690b0fc7ee6199eb20c', pt=>'6cf1d98a58b5683e403ea6747a02b2b6b3697114a5d8234f63637cf7327c8df19eafc185710d53ff762de59babc66ae3d5697ca7dd38ea00bebb741434dd7d8dab52b9876c9c4cefdd36c6b0c716108273f7d3d23f7970990f09f9530276236489b64a0079347cb14eb82106fc2945a40553392f3d964b677870fe6aeeebf159eba6',  ct=>'ff829a0e6e21de39a5a3733a7f6d4b52e8a72e97a7192afeaa29c63c12bc57b61f5ab04b3cde81d557ad57f5c1771b24ededea0f2a7a3819d9d463f5c195503c145283c762ba6adf876fae4efb8b22c24a036b6d27f4d65c6c9db5d584e504af2afc6e932b67f24e07fae51c6e14a981aec4fac5161a523e944529bdeba100a3b366d5c6a730a7e9382a7a824d31c463' },
    { padding=>1, key=>'6ed4b7d127dce8bb15d6d772e043e5f4297d0c936671572823db00346fe8c54f', iv=>'c148a482405a6adc4aa7bd55d4fb9c5b', pt=>'982cd450603380b0001449817ea73efed17581846178e308e8e732e4001a7843fbfdc9e1c1b3f136e01008225c67d3be503adf82795257754c0b1e02d8415da82b8cb47e537f9c6f9c21571c52eab3c7fcc91a94e9b4fca0b5f032d302ef8c592cc54647ff1f58ede5001b6a65f28a00029519b38801843cfe9c63f088ec575cecf2',  ct=>'4731d8fc61ea27f54595314239b0c6ea9708dc8044950725e0814e47d4bcee32fc88b1734933688e3df66479f74d47000cb88d19d40c01415db4abe1c2008196c7cee60c173943d9360fcea6b05fae17ead1e879f4f8bc4e085c73732dc2c5f9aed46c6d3dc63354d1b7d08f4fff00eed533889e895a5897fef338185deee24ccd225713b4a3e4cb3db6e949dd83f0a0' },
    { padding=>0, key=>'d0f6307a64837231f7ef94a8100fab507e31eb180a4b0f514f4128f431b19d92', iv=>'53095c611e2172debd73a7780ab8fd6e', pt=>'da7a390b0b83b4c7f054a09d382876135997bb00d73f59bc36c1d1d7943d241c4fc91f670978e0144d1ffe1dac6d80989b35518642ffa1a854fdb4d6aedab71a97b64cedadafff46476d97830bbd9f8a9ef16381ee59f1e504e6284ff1b4328bc494e55acbf15f61c644611ac24acd770ed984318ec151fd9637b1cd0e67f570',  ct=>'a653d2ef928cf109351a01953cd53795fb7baf9e22e6863c3df0a384ab1b13a53777f881a60e10d192a88e0db2066ad85accfa438de56b4c191cf2ec69bdf89744b7f0bd6b466912fcebbdeea53bd957c42396bf983f0633df91109e790b598099d6c1604aacb11e03135c30953ec9b23f2d14cdaac46ef56eedbdedff5596c7' },
  );
  for (@t) {
    my $pt = pack("H*", $_->{pt});
    my $ct = pack("H*", $_->{ct});
    my $m = Crypt::Mode::CBC->new('AES', $_->{padding});

    for my $l (1..33) {
    
      {
        $m->start_encrypt(pack("H*",$_->{key}), pack("H*",$_->{iv}));
        my $i = 0;
        my $ct = '';
        while ($i < length($pt)) {
          $ct .= $m->add(substr($pt, $i, $l));
          $i += $l;
        }
        $ct .= $m->finish;
        is(unpack("H*",$ct), $_->{ct}, "cipher text match [l=$l]");
      }
      
      {
        $m->start_decrypt(pack("H*",$_->{key}), pack("H*",$_->{iv}));
        my $i = 0;
        my $pt = '';
        while ($i < length($ct)) {
          $pt .= $m->add(substr($ct, $i, $l));
          $i += $l;
        }
        $pt .= $m->finish;
        is(unpack("H*",$pt), $_->{pt}, "plain text match  [l=$l]");
      }
      
    }    
  }
}

done_testing;