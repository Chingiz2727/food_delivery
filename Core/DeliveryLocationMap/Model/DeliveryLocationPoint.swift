//
//  DeliveryLocationPoint.swift
//  Pilican
//
//  Created by kairzhan on 5/21/21.
//

import Foundation
import YandexMapsMobile

struct LocationArea {
    let location: [YMKPoint] =
        [
            .init(latitude: 69.6342659, longitude: 42.4127480),
            .init(latitude: 69.6255970, longitude: 42.4142689),
            .init(latitude: 69.6164131, longitude: 42.4139520),
            .init(latitude: 69.6045685, longitude: 42.4132550),
            .init(latitude: 69.5956421, longitude: 42.4149025),
            .init(latitude: 69.5881748, longitude: 42.4131916),
            .init(latitude: 69.5837975, longitude: 42.4102766),
            .init(latitude: 69.5808792, longitude: 42.4073614),
            .init(latitude: 69.5681763, longitude: 42.3972206),
            .init(latitude: 69.5649147, longitude: 42.3948120),
            .init(latitude: 69.5616961, longitude: 42.3923398),
            .init(latitude: 69.5589495, longitude: 42.3904064),
            .init(latitude: 69.5549583, longitude: 42.3880925),
            .init(latitude: 69.5448303, longitude: 42.3806116),
            .init(latitude: 69.5318699, longitude: 42.3851763),
            .init(latitude: 69.5304966, longitude: 42.3865394),
            .init(latitude: 69.5285654, longitude: 42.3876805),
            .init(latitude: 69.5174503, longitude: 42.3901845),
            .init(latitude: 69.5031166, longitude: 42.3929103),
            .init(latitude: 69.4964218, longitude: 42.3901211),
            .init(latitude: 69.4933319, longitude: 42.3854933),
            .init(latitude: 69.4917011, longitude: 42.3818162),
            .init(latitude: 69.4989109, longitude: 42.3763635),
            .init(latitude: 69.4955850, longitude: 42.3764903),
            .init(latitude: 69.4938254, longitude: 42.3772988),
            .init(latitude: 69.4854355, longitude: 42.3778219),
            .init(latitude: 69.4852424, longitude: 42.3738589),
            .init(latitude: 69.4789982, longitude: 42.3745881),
            .init(latitude: 69.4759512, longitude: 42.3759197),
            .init(latitude: 69.4726467, longitude: 42.3758087),
            .init(latitude: 69.4690418, longitude: 42.3761416),
            .init(latitude: 69.4673896, longitude: 42.3772512),
            .init(latitude: 69.4653726, longitude: 42.3773622),
            .init(latitude: 69.4640636, longitude: 42.3763477),
            .init(latitude: 69.4588923, longitude: 42.3716713),
            .init(latitude: 69.4480991, longitude: 42.3617785),
            .init(latitude: 69.4859505, longitude: 42.3506789),
            .init(latitude: 69.5022583, longitude: 42.3434472),
            .init(latitude: 69.5080519, longitude: 42.3399262),
            .init(latitude: 69.5111847, longitude: 42.3378643),
            .init(latitude: 69.5144463, longitude: 42.3362782),
            .init(latitude: 69.5154333, longitude: 42.3360561),
            .init(latitude: 69.5166349, longitude: 42.3353899),
            .init(latitude: 69.5170212, longitude: 42.3351996),
            .init(latitude: 69.5174503, longitude: 42.3350727),
            .init(latitude: 69.5145321, longitude: 42.3305043),
            .init(latitude: 69.5146179, longitude: 42.3240318),
            .init(latitude: 69.5246601, longitude: 42.3166701),
            .init(latitude: 69.5340157, longitude: 42.3091807),
            .init(latitude: 69.5416546, longitude: 42.3013729),
            .init(latitude: 69.5498943, longitude: 42.2971830),
            .init(latitude: 69.5547009, longitude: 42.2941991),
            .init(latitude: 69.5617390, longitude: 42.2907071),
            .init(latitude: 69.5647430, longitude: 42.2888023),
            .init(latitude: 69.5698929, longitude: 42.2868974),
            .init(latitude: 69.5650005, longitude: 42.2804205),
            .init(latitude: 69.5638847, longitude: 42.2783249),
            .init(latitude: 69.5724678, longitude: 42.2748955),
            .init(latitude: 69.5824242, longitude: 42.2768642),
            .init(latitude: 69.5904064, longitude: 42.2768642),
            .init(latitude: 69.5965862, longitude: 42.2735618),
            .init(latitude: 69.6027660, longitude: 42.2726092),
            .init(latitude: 69.6110058, longitude: 42.2781343),
            .init(latitude: 69.6162415, longitude: 42.2862625),
            .init(latitude: 69.6153402, longitude: 42.2941673),
            .init(latitude: 69.6186018, longitude: 42.2962624),
            .init(latitude: 69.6170568, longitude: 42.2979131),
            .init(latitude: 69.6167994, longitude: 42.3009920),
            .init(latitude: 69.6169281, longitude: 42.3016903),
            .init(latitude: 69.6162415, longitude: 42.3026743),
            .init(latitude: 69.6167564, longitude: 42.3036582),
            .init(latitude: 69.6170998, longitude: 42.3039121),
            .init(latitude: 69.6207905, longitude: 42.3032139),
            .init(latitude: 69.6230650, longitude: 42.3019125),
            .init(latitude: 69.6254683, longitude: 42.3013094),
            .init(latitude: 69.6295023, longitude: 42.3001350),
            .init(latitude: 69.6320343, longitude: 42.3008016),
            .init(latitude: 69.6355963, longitude: 42.3020395),
            .init(latitude: 69.6400595, longitude: 42.3035947),
            .init(latitude: 69.6416903, longitude: 42.3042930),
            .init(latitude: 69.6460676, longitude: 42.3062291),
            .init(latitude: 69.6525908, longitude: 42.3086412),
            .init(latitude: 69.6590710, longitude: 42.3111483),
            .init(latitude: 69.6650791, longitude: 42.3126082),
            .init(latitude: 69.6691990, longitude: 42.3129890),
            .init(latitude: 69.6716881, longitude: 42.3144488),
            .init(latitude: 69.6730614, longitude: 42.3166701),
            .init(latitude: 69.6728897, longitude: 42.3189549),
            .init(latitude: 69.6703148, longitude: 42.3198434),
            .init(latitude: 69.6682549, longitude: 42.3206684),
            .init(latitude: 69.6640491, longitude: 42.3204780),
            .init(latitude: 69.6607661, longitude: 42.3196054),
            .init(latitude: 69.6574187, longitude: 42.3190501),
            .init(latitude: 69.6555948, longitude: 42.3190818),
            .init(latitude: 69.6537495, longitude: 42.3197482),
            .init(latitude: 69.6525908, longitude: 42.3206843),
            .init(latitude: 69.6518397, longitude: 42.3223977),
            .init(latitude: 69.6518612, longitude: 42.3240159),
            .init(latitude: 69.6527195, longitude: 42.3249519),
            .init(latitude: 69.6550369, longitude: 42.3266494),
            .init(latitude: 69.6571827, longitude: 42.3275854),
            .init(latitude: 69.6598434, longitude: 42.3289814),
            .init(latitude: 69.6637058, longitude: 42.3301711),
            .init(latitude: 69.6678472, longitude: 42.3310277),
            .init(latitude: 69.6729755, longitude: 42.3321381),
            .init(latitude: 69.6769452, longitude: 42.3329313),
            .init(latitude: 69.6798420, longitude: 42.3345334),
            .init(latitude: 69.6814942, longitude: 42.3362464),
            .init(latitude: 69.6837687, longitude: 42.3383401),
            .init(latitude: 69.6852064, longitude: 42.3396724),
            .init(latitude: 69.6881890, longitude: 42.3413061),
            .init(latitude: 69.6911287, longitude: 42.3426383),
            .init(latitude: 69.6929312, longitude: 42.3433362),
            .init(latitude: 69.6959138, longitude: 42.3448111),
            .init(latitude: 69.6981668, longitude: 42.3459689),
            .init(latitude: 69.7010207, longitude: 42.3472852),
            .init(latitude: 69.7038102, longitude: 42.3484587),
            .init(latitude: 69.7119427, longitude: 42.3525183),
            .init(latitude: 69.7149038, longitude: 42.3536601),
            .init(latitude: 69.7175217, longitude: 42.3550396),
            .init(latitude: 69.7197104, longitude: 42.3559911),
            .init(latitude: 69.7228217, longitude: 42.3575608),
            .init(latitude: 69.7257185, longitude: 42.3588927),
            .init(latitude: 69.7291303, longitude: 42.3606686),
            .init(latitude: 69.7294092, longitude: 42.3615089),
            .init(latitude: 69.7281003, longitude: 42.3622541),
            .init(latitude: 69.7265553, longitude: 42.3629042),
            .init(latitude: 69.7210407, longitude: 42.3656787),
            .init(latitude: 69.7153330, longitude: 42.3689763),
            .init(latitude: 69.7097111, longitude: 42.3719250),
            .init(latitude: 69.7024155, longitude: 42.3738272),
            .init(latitude: 69.6975660, longitude: 42.3752856),
            .init(latitude: 69.6912146, longitude: 42.3764269),
            .init(latitude: 69.6827602, longitude: 42.3770293),
            .init(latitude: 69.6756363, longitude: 42.3776316),
            .init(latitude: 69.6756363, longitude: 42.3792801),
            .init(latitude: 69.6735764, longitude: 42.3805482),
            .init(latitude: 69.6705723, longitude: 42.3817528),
            .init(latitude: 69.6672249, longitude: 42.3825136),
            .init(latitude: 69.6649933, longitude: 42.3834646),
            .init(latitude: 69.6620750, longitude: 42.3842888),
            .init(latitude: 69.6597576, longitude: 42.3854299),
            .init(latitude: 69.6574402, longitude: 42.3863809),
            .init(latitude: 69.6563673, longitude: 42.3876488),
            .init(latitude: 69.6561956, longitude: 42.3895506),
            .init(latitude: 69.6567965, longitude: 42.3922764),
            .init(latitude: 69.6567535, longitude: 42.3943366),
            .init(latitude: 69.6570539, longitude: 42.3964917),
            .init(latitude: 69.6576548, longitude: 42.3980129),
            .init(latitude: 69.6602726, longitude: 42.4006116),
            .init(latitude: 69.6616888, longitude: 42.4024180),
            .init(latitude: 69.6633196, longitude: 42.4037489),
            .init(latitude: 69.6668386, longitude: 42.4066326),
            .init(latitude: 69.6659374, longitude: 42.4075832),
            .init(latitude: 69.6622896, longitude: 42.4088190),
            .init(latitude: 69.6604443, longitude: 42.4091676),
            .init(latitude: 69.6562815, longitude: 42.4089458),
            .init(latitude: 69.6525049, longitude: 42.4097696),
            .init(latitude: 69.6495438, longitude: 42.4103716),
            .init(latitude: 69.6464109, longitude: 42.4111004),
            .init(latitude: 69.6434927, longitude: 42.4114489),
            .init(latitude: 69.6411324, longitude: 42.4118292),
            .init(latitude: 69.6379137, longitude: 42.4122728),
            .init(latitude: 69.6342659, longitude: 42.4127163)
        ]
}
