//
//  NagrandBase.h
//  Nagrand
//
//  Created by Sanae on 15/12/29.
//  Copyright © 2015年 Palmap+ Co. Ltd. All rights reserved.
//


// Definition of 'NGR_EXTERN'.
#if !defined(NGR_EXTERN)
# if defined(__cplusplus)
#  define NGR_EXTERN extern "C"
# else
#  define NGR_EXTERN extern
# endif
#endif

// Definition of 'NGR_INLINE'.
#if !defined(NGR_INLINE)
# if defined(__STDC_VERSION__) && __STDC_VERSION__ >= 199901L
#  define NGR_INLINE static inline
# elif defined(__cplusplus)
#  define NGR_INLINE static inline
# elif defined(__GNUC__)
#  define NGR_INLINE static __inline__
# else
#  define NGR_INLINE static
# endif
#endif


