/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                         */
/*  \   \        Copyright (c) 2003-2007 Xilinx, Inc.                 */
/*  /   /        All Right Reserved.                                  */
/* /---/   /\                                                         */
/* \   \  /  \                                                        */
/*  \___\/\___\                                                       */
/**********************************************************************/

/* This file is designed for use with ISim build 0x9330dbfa */

#include "xsi.h"
#include <memory.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
static const char *ng0 = "/home/atana/RTI/dnepr/hw/mm010_dd13/pcores/dnepr_fu_v1_00_a/devl/projnav/../../hdl/vhdl/fsm.vhd";
extern char *IEEE_P_2592010699;
extern char *IEEE_P_3620187407;

unsigned char ieee_p_3620187407_sub_1684765609_3620187407(char *, char *, char *, char *, char *);
char *ieee_p_3620187407_sub_4215186851_3620187407(char *, char *, char *, char *, char *, char *);
char *ieee_p_3620187407_sub_4215258725_3620187407(char *, char *, char *, char *, char *, char *);
unsigned char ieee_std_logic_unsigned_equal_stdv_stdv(char *, char *, char *, char *, char *);
unsigned char ieee_std_logic_unsigned_greater_stdv_stdv(char *, char *, char *, char *, char *);


static void work_a_3643194780_3212880686_p_0(char *t0)
{
    unsigned char t1;
    char *t2;
    unsigned char t3;
    char *t4;
    char *t5;
    unsigned char t6;
    unsigned char t7;
    char *t8;
    unsigned char t9;
    unsigned char t10;
    char *t11;
    char *t12;
    char *t13;
    char *t14;

LAB0:    xsi_set_current_line(58, ng0);
    t2 = (t0 + 528U);
    t3 = xsi_signal_has_event(t2);
    if (t3 == 1)
        goto LAB5;

LAB6:    t1 = (unsigned char)0;

LAB7:    if (t1 != 0)
        goto LAB2;

LAB4:
LAB3:    t2 = (t0 + 4916);
    *((int *)t2) = 1;

LAB1:    return;
LAB2:    xsi_set_current_line(59, ng0);
    t4 = (t0 + 636U);
    t8 = *((char **)t4);
    t9 = *((unsigned char *)t8);
    t10 = (t9 == (unsigned char)3);
    if (t10 != 0)
        goto LAB8;

LAB10:    xsi_set_current_line(62, ng0);
    t2 = (t0 + 1868U);
    t4 = *((char **)t2);
    t1 = *((unsigned char *)t4);
    t2 = (t0 + 5048);
    t5 = (t2 + 32U);
    t8 = *((char **)t5);
    t11 = (t8 + 32U);
    t12 = *((char **)t11);
    *((unsigned char *)t12) = t1;
    xsi_driver_first_trans_fast(t2);

LAB9:    goto LAB3;

LAB5:    t4 = (t0 + 548U);
    t5 = *((char **)t4);
    t6 = *((unsigned char *)t5);
    t7 = (t6 == (unsigned char)3);
    t1 = t7;
    goto LAB7;

LAB8:    xsi_set_current_line(60, ng0);
    t4 = (t0 + 5048);
    t11 = (t4 + 32U);
    t12 = *((char **)t11);
    t13 = (t12 + 32U);
    t14 = *((char **)t13);
    *((unsigned char *)t14) = (unsigned char)0;
    xsi_driver_first_trans_fast(t4);
    goto LAB9;

}

static void work_a_3643194780_3212880686_p_1(char *t0)
{
    char *t1;
    char *t2;
    unsigned char t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;
    unsigned char t8;
    unsigned char t9;
    char *t10;
    char *t11;
    static char *nl0[] = {&&LAB3, &&LAB4, &&LAB5, &&LAB6, &&LAB7, &&LAB8};

LAB0:    xsi_set_current_line(69, ng0);
    t1 = (t0 + 1780U);
    t2 = *((char **)t1);
    t3 = *((unsigned char *)t2);
    t1 = (t0 + 5084);
    t4 = (t1 + 32U);
    t5 = *((char **)t4);
    t6 = (t5 + 32U);
    t7 = *((char **)t6);
    *((unsigned char *)t7) = t3;
    xsi_driver_first_trans_fast(t1);
    xsi_set_current_line(70, ng0);
    t1 = (t0 + 1780U);
    t2 = *((char **)t1);
    t3 = *((unsigned char *)t2);
    t1 = (char *)((nl0) + t3);
    goto **((char **)t1);

LAB2:    t1 = (t0 + 4924);
    *((int *)t1) = 1;

LAB1:    return;
LAB3:    xsi_set_current_line(72, ng0);
    t4 = (t0 + 1428U);
    t5 = *((char **)t4);
    t8 = *((unsigned char *)t5);
    t9 = (t8 == (unsigned char)2);
    if (t9 != 0)
        goto LAB10;

LAB12:
LAB11:    goto LAB2;

LAB4:    xsi_set_current_line(76, ng0);
    t1 = (t0 + 5084);
    t2 = (t1 + 32U);
    t4 = *((char **)t2);
    t5 = (t4 + 32U);
    t6 = *((char **)t5);
    *((unsigned char *)t6) = (unsigned char)2;
    xsi_driver_first_trans_fast(t1);
    goto LAB2;

LAB5:    xsi_set_current_line(78, ng0);
    t1 = (t0 + 5084);
    t2 = (t1 + 32U);
    t4 = *((char **)t2);
    t5 = (t4 + 32U);
    t6 = *((char **)t5);
    *((unsigned char *)t6) = (unsigned char)3;
    xsi_driver_first_trans_fast(t1);
    goto LAB2;

LAB6:    xsi_set_current_line(80, ng0);
    t1 = (t0 + 5084);
    t2 = (t1 + 32U);
    t4 = *((char **)t2);
    t5 = (t4 + 32U);
    t6 = *((char **)t5);
    *((unsigned char *)t6) = (unsigned char)4;
    xsi_driver_first_trans_fast(t1);
    goto LAB2;

LAB7:    xsi_set_current_line(82, ng0);
    t1 = (t0 + 2044U);
    t2 = *((char **)t1);
    t3 = *((unsigned char *)t2);
    t8 = (t3 == (unsigned char)3);
    if (t8 != 0)
        goto LAB13;

LAB15:    xsi_set_current_line(85, ng0);
    t1 = (t0 + 5084);
    t2 = (t1 + 32U);
    t4 = *((char **)t2);
    t5 = (t4 + 32U);
    t6 = *((char **)t5);
    *((unsigned char *)t6) = (unsigned char)0;
    xsi_driver_first_trans_fast(t1);

LAB14:    goto LAB2;

LAB8:    xsi_set_current_line(88, ng0);
    t1 = (t0 + 1956U);
    t2 = *((char **)t1);
    t3 = *((unsigned char *)t2);
    t8 = (t3 == (unsigned char)3);
    if (t8 != 0)
        goto LAB16;

LAB18:
LAB17:    goto LAB2;

LAB9:    xsi_set_current_line(92, ng0);
    t1 = (t0 + 5084);
    t2 = (t1 + 32U);
    t4 = *((char **)t2);
    t5 = (t4 + 32U);
    t6 = *((char **)t5);
    *((unsigned char *)t6) = (unsigned char)0;
    xsi_driver_first_trans_fast(t1);
    goto LAB2;

LAB10:    xsi_set_current_line(73, ng0);
    t4 = (t0 + 5084);
    t6 = (t4 + 32U);
    t7 = *((char **)t6);
    t10 = (t7 + 32U);
    t11 = *((char **)t10);
    *((unsigned char *)t11) = (unsigned char)1;
    xsi_driver_first_trans_fast(t4);
    goto LAB11;

LAB13:    xsi_set_current_line(83, ng0);
    t1 = (t0 + 5084);
    t4 = (t1 + 32U);
    t5 = *((char **)t4);
    t6 = (t5 + 32U);
    t7 = *((char **)t6);
    *((unsigned char *)t7) = (unsigned char)5;
    xsi_driver_first_trans_fast(t1);
    goto LAB14;

LAB16:    xsi_set_current_line(89, ng0);
    t1 = (t0 + 5084);
    t4 = (t1 + 32U);
    t5 = *((char **)t4);
    t6 = (t5 + 32U);
    t7 = *((char **)t6);
    *((unsigned char *)t7) = (unsigned char)0;
    xsi_driver_first_trans_fast(t1);
    goto LAB17;

}

static void work_a_3643194780_3212880686_p_2(char *t0)
{
    unsigned char t1;
    char *t2;
    unsigned char t3;
    char *t4;
    char *t5;
    unsigned char t6;
    unsigned char t7;
    char *t8;
    unsigned char t9;
    unsigned char t10;
    char *t11;
    char *t12;
    char *t13;
    char *t14;

LAB0:    xsi_set_current_line(98, ng0);
    t2 = (t0 + 528U);
    t3 = xsi_signal_has_event(t2);
    if (t3 == 1)
        goto LAB5;

LAB6:    t1 = (unsigned char)0;

LAB7:    if (t1 != 0)
        goto LAB2;

LAB4:
LAB3:    t2 = (t0 + 4932);
    *((int *)t2) = 1;

LAB1:    return;
LAB2:    xsi_set_current_line(99, ng0);
    t4 = (t0 + 1780U);
    t8 = *((char **)t4);
    t9 = *((unsigned char *)t8);
    t10 = (t9 == (unsigned char)1);
    if (t10 != 0)
        goto LAB8;

LAB10:    xsi_set_current_line(102, ng0);
    t2 = (t0 + 5120);
    t4 = (t2 + 32U);
    t5 = *((char **)t4);
    t8 = (t5 + 32U);
    t11 = *((char **)t8);
    *((unsigned char *)t11) = (unsigned char)2;
    xsi_driver_first_trans_fast_port(t2);

LAB9:    goto LAB3;

LAB5:    t4 = (t0 + 548U);
    t5 = *((char **)t4);
    t6 = *((unsigned char *)t5);
    t7 = (t6 == (unsigned char)3);
    t1 = t7;
    goto LAB7;

LAB8:    xsi_set_current_line(100, ng0);
    t4 = (t0 + 5120);
    t11 = (t4 + 32U);
    t12 = *((char **)t11);
    t13 = (t12 + 32U);
    t14 = *((char **)t13);
    *((unsigned char *)t14) = (unsigned char)3;
    xsi_driver_first_trans_fast_port(t4);
    goto LAB9;

}

static void work_a_3643194780_3212880686_p_3(char *t0)
{
    char t4[16];
    char *t1;
    char *t2;
    char *t3;
    char *t5;
    char *t6;
    char *t7;
    char *t8;
    char *t9;
    char *t10;
    char *t11;
    char *t12;
    char *t13;

LAB0:    xsi_set_current_line(107, ng0);

LAB3:    t1 = (t0 + 724U);
    t2 = *((char **)t1);
    t1 = (t0 + 812U);
    t3 = *((char **)t1);
    t5 = ((IEEE_P_2592010699) + 2224);
    t6 = (t0 + 7560U);
    t7 = (t0 + 7576U);
    t1 = xsi_base_array_concat(t1, t4, t5, (char)97, t2, t6, (char)97, t3, t7, (char)101);
    t8 = (t0 + 5156);
    t9 = (t8 + 32U);
    t10 = *((char **)t9);
    t11 = (t10 + 32U);
    t12 = *((char **)t11);
    memcpy(t12, t1, 32U);
    xsi_driver_first_trans_fast(t8);

LAB2:    t13 = (t0 + 4940);
    *((int *)t13) = 1;

LAB1:    return;
LAB4:    goto LAB2;

}

static void work_a_3643194780_3212880686_p_4(char *t0)
{
    char t8[16];
    unsigned char t1;
    char *t2;
    unsigned char t3;
    char *t4;
    char *t5;
    unsigned char t6;
    unsigned char t7;
    char *t9;
    char *t10;
    char *t11;
    char *t12;
    char *t13;
    char *t14;
    char *t15;
    char *t16;
    char *t17;

LAB0:    xsi_set_current_line(110, ng0);
    t2 = (t0 + 528U);
    t3 = xsi_signal_has_event(t2);
    if (t3 == 1)
        goto LAB5;

LAB6:    t1 = (unsigned char)0;

LAB7:    if (t1 != 0)
        goto LAB2;

LAB4:
LAB3:    t2 = (t0 + 4948);
    *((int *)t2) = 1;

LAB1:    return;
LAB2:    xsi_set_current_line(111, ng0);
    t4 = (t0 + 2132U);
    t9 = *((char **)t4);
    t4 = (t0 + 7688U);
    t10 = (t0 + 900U);
    t11 = *((char **)t10);
    t10 = (t0 + 7592U);
    t12 = ieee_p_3620187407_sub_4215186851_3620187407(IEEE_P_3620187407, t8, t9, t4, t11, t10);
    t13 = (t0 + 5192);
    t14 = (t13 + 32U);
    t15 = *((char **)t14);
    t16 = (t15 + 32U);
    t17 = *((char **)t16);
    memcpy(t17, t12, 32U);
    xsi_driver_first_trans_fast(t13);
    xsi_set_current_line(112, ng0);
    t2 = (t0 + 2220U);
    t4 = *((char **)t2);
    t2 = (t0 + 7704U);
    t5 = (t0 + 988U);
    t9 = *((char **)t5);
    t5 = (t0 + 7608U);
    t10 = ieee_p_3620187407_sub_4215186851_3620187407(IEEE_P_3620187407, t8, t4, t2, t9, t5);
    t11 = (t0 + 5228);
    t12 = (t11 + 32U);
    t13 = *((char **)t12);
    t14 = (t13 + 32U);
    t15 = *((char **)t14);
    memcpy(t15, t10, 32U);
    xsi_driver_first_trans_fast(t11);
    goto LAB3;

LAB5:    t4 = (t0 + 548U);
    t5 = *((char **)t4);
    t6 = *((unsigned char *)t5);
    t7 = (t6 == (unsigned char)3);
    t1 = t7;
    goto LAB7;

}

static void work_a_3643194780_3212880686_p_5(char *t0)
{
    char t4[16];
    char *t1;
    char *t2;
    char *t3;
    char *t5;
    char *t6;
    char *t7;
    char *t8;
    char *t9;
    char *t10;
    char *t11;
    char *t12;
    char *t13;

LAB0:    xsi_set_current_line(118, ng0);

LAB3:    t1 = (t0 + 1076U);
    t2 = *((char **)t1);
    t1 = (t0 + 1164U);
    t3 = *((char **)t1);
    t5 = ((IEEE_P_2592010699) + 2224);
    t6 = (t0 + 7624U);
    t7 = (t0 + 7640U);
    t1 = xsi_base_array_concat(t1, t4, t5, (char)97, t2, t6, (char)97, t3, t7, (char)101);
    t8 = (t0 + 5264);
    t9 = (t8 + 32U);
    t10 = *((char **)t9);
    t11 = (t10 + 32U);
    t12 = *((char **)t11);
    memcpy(t12, t1, 32U);
    xsi_driver_first_trans_fast(t8);

LAB2:    t13 = (t0 + 4956);
    *((int *)t13) = 1;

LAB1:    return;
LAB4:    goto LAB2;

}

static void work_a_3643194780_3212880686_p_6(char *t0)
{
    char t4[16];
    char *t1;
    char *t2;
    char *t3;
    char *t5;
    char *t6;
    char *t7;
    char *t8;
    char *t9;
    char *t10;
    char *t11;
    char *t12;
    char *t13;

LAB0:    xsi_set_current_line(119, ng0);

LAB3:    t1 = (t0 + 1252U);
    t2 = *((char **)t1);
    t1 = (t0 + 1340U);
    t3 = *((char **)t1);
    t5 = ((IEEE_P_2592010699) + 2224);
    t6 = (t0 + 7656U);
    t7 = (t0 + 7672U);
    t1 = xsi_base_array_concat(t1, t4, t5, (char)97, t2, t6, (char)97, t3, t7, (char)101);
    t8 = (t0 + 5300);
    t9 = (t8 + 32U);
    t10 = *((char **)t9);
    t11 = (t10 + 32U);
    t12 = *((char **)t11);
    memcpy(t12, t1, 32U);
    xsi_driver_first_trans_fast(t8);

LAB2:    t13 = (t0 + 4964);
    *((int *)t13) = 1;

LAB1:    return;
LAB4:    goto LAB2;

}

static void work_a_3643194780_3212880686_p_7(char *t0)
{
    char t8[16];
    char t23[16];
    char t27[16];
    char t30[16];
    char t36[16];
    unsigned char t1;
    char *t2;
    unsigned char t3;
    char *t4;
    char *t5;
    unsigned char t6;
    unsigned char t7;
    char *t9;
    char *t10;
    char *t11;
    char *t12;
    char *t13;
    char *t14;
    char *t15;
    char *t16;
    char *t17;
    unsigned int t18;
    unsigned int t19;
    unsigned int t20;
    int t21;
    unsigned int t22;
    int t24;
    unsigned int t25;
    unsigned int t26;
    int t28;
    unsigned int t29;
    char *t31;
    int t32;
    char *t33;
    char *t34;
    char *t37;
    char *t38;
    int t39;
    unsigned char t40;
    char *t41;
    char *t42;
    char *t43;
    char *t44;

LAB0:    xsi_set_current_line(123, ng0);
    t2 = (t0 + 528U);
    t3 = xsi_signal_has_event(t2);
    if (t3 == 1)
        goto LAB5;

LAB6:    t1 = (unsigned char)0;

LAB7:    if (t1 != 0)
        goto LAB2;

LAB4:
LAB3:    t2 = (t0 + 4972);
    *((int *)t2) = 1;

LAB1:    return;
LAB2:    xsi_set_current_line(124, ng0);
    t4 = (t0 + 2396U);
    t9 = *((char **)t4);
    t4 = (t0 + 7736U);
    t10 = (t0 + 2308U);
    t11 = *((char **)t10);
    t10 = (t0 + 7720U);
    t12 = ieee_p_3620187407_sub_4215258725_3620187407(IEEE_P_3620187407, t8, t9, t4, t11, t10);
    t13 = (t0 + 5336);
    t14 = (t13 + 32U);
    t15 = *((char **)t14);
    t16 = (t15 + 32U);
    t17 = *((char **)t16);
    memcpy(t17, t12, 32U);
    xsi_driver_first_trans_fast(t13);
    xsi_set_current_line(125, ng0);
    t2 = (t0 + 2484U);
    t4 = *((char **)t2);
    t2 = (t0 + 7752U);
    t5 = (t0 + 2396U);
    t9 = *((char **)t5);
    t5 = (t0 + 7736U);
    t10 = ieee_p_3620187407_sub_4215258725_3620187407(IEEE_P_3620187407, t8, t4, t2, t9, t5);
    t11 = (t0 + 5372);
    t12 = (t11 + 32U);
    t13 = *((char **)t12);
    t14 = (t13 + 32U);
    t15 = *((char **)t14);
    memcpy(t15, t10, 32U);
    xsi_driver_first_trans_fast(t11);
    xsi_set_current_line(127, ng0);
    t2 = (t0 + 2572U);
    t4 = *((char **)t2);
    t18 = (31 - 31);
    t19 = (t18 * 1U);
    t20 = (0 + t19);
    t2 = (t4 + t20);
    t5 = (t8 + 0U);
    t9 = (t5 + 0U);
    *((int *)t9) = 31;
    t9 = (t5 + 4U);
    *((int *)t9) = 16;
    t9 = (t5 + 8U);
    *((int *)t9) = -1;
    t21 = (16 - 31);
    t22 = (t21 * -1);
    t22 = (t22 + 1);
    t9 = (t5 + 12U);
    *((unsigned int *)t9) = t22;
    t9 = (t0 + 8038);
    t11 = (t23 + 0U);
    t12 = (t11 + 0U);
    *((int *)t12) = 0;
    t12 = (t11 + 4U);
    *((int *)t12) = 15;
    t12 = (t11 + 8U);
    *((int *)t12) = 1;
    t24 = (15 - 0);
    t22 = (t24 * 1);
    t22 = (t22 + 1);
    t12 = (t11 + 12U);
    *((unsigned int *)t12) = t22;
    t6 = ieee_p_3620187407_sub_1684765609_3620187407(IEEE_P_3620187407, t2, t8, t9, t23);
    if (t6 == 1)
        goto LAB14;

LAB15:    t3 = (unsigned char)0;

LAB16:    if (t3 == 1)
        goto LAB11;

LAB12:    t1 = (unsigned char)0;

LAB13:    if (t1 != 0)
        goto LAB8;

LAB10:    xsi_set_current_line(130, ng0);
    t2 = (t0 + 5408);
    t4 = (t2 + 32U);
    t5 = *((char **)t4);
    t9 = (t5 + 32U);
    t10 = *((char **)t9);
    *((unsigned char *)t10) = (unsigned char)2;
    xsi_driver_first_trans_fast(t2);

LAB9:    goto LAB3;

LAB5:    t4 = (t0 + 548U);
    t5 = *((char **)t4);
    t6 = *((unsigned char *)t5);
    t7 = (t6 == (unsigned char)3);
    t1 = t7;
    goto LAB7;

LAB8:    xsi_set_current_line(128, ng0);
    t38 = (t0 + 5408);
    t41 = (t38 + 32U);
    t42 = *((char **)t41);
    t43 = (t42 + 32U);
    t44 = *((char **)t43);
    *((unsigned char *)t44) = (unsigned char)3;
    xsi_driver_first_trans_fast(t38);
    goto LAB9;

LAB11:    t31 = (t0 + 2660U);
    t33 = *((char **)t31);
    t31 = (t0 + 7784U);
    t34 = (t0 + 8074);
    t37 = (t36 + 0U);
    t38 = (t37 + 0U);
    *((int *)t38) = 0;
    t38 = (t37 + 4U);
    *((int *)t38) = 31;
    t38 = (t37 + 8U);
    *((int *)t38) = 1;
    t39 = (31 - 0);
    t29 = (t39 * 1);
    t29 = (t29 + 1);
    t38 = (t37 + 12U);
    *((unsigned int *)t38) = t29;
    t40 = ieee_p_3620187407_sub_1684765609_3620187407(IEEE_P_3620187407, t33, t31, t34, t36);
    t1 = t40;
    goto LAB13;

LAB14:    t12 = (t0 + 2572U);
    t13 = *((char **)t12);
    t22 = (31 - 19);
    t25 = (t22 * 1U);
    t26 = (0 + t25);
    t12 = (t13 + t26);
    t14 = (t27 + 0U);
    t15 = (t14 + 0U);
    *((int *)t15) = 19;
    t15 = (t14 + 4U);
    *((int *)t15) = 0;
    t15 = (t14 + 8U);
    *((int *)t15) = -1;
    t28 = (0 - 19);
    t29 = (t28 * -1);
    t29 = (t29 + 1);
    t15 = (t14 + 12U);
    *((unsigned int *)t15) = t29;
    t15 = (t0 + 8054);
    t17 = (t30 + 0U);
    t31 = (t17 + 0U);
    *((int *)t31) = 0;
    t31 = (t17 + 4U);
    *((int *)t31) = 19;
    t31 = (t17 + 8U);
    *((int *)t31) = 1;
    t32 = (19 - 0);
    t29 = (t32 * 1);
    t29 = (t29 + 1);
    t31 = (t17 + 12U);
    *((unsigned int *)t31) = t29;
    t7 = ieee_std_logic_unsigned_greater_stdv_stdv(IEEE_P_3620187407, t12, t27, t15, t30);
    t3 = t7;
    goto LAB16;

}

static void work_a_3643194780_3212880686_p_8(char *t0)
{
    unsigned char t1;
    char *t2;
    unsigned char t3;
    char *t4;
    char *t5;
    unsigned char t6;
    unsigned char t7;
    char *t8;
    unsigned char t9;
    unsigned char t10;
    char *t11;
    char *t12;
    char *t13;
    char *t14;
    char *t15;

LAB0:    xsi_set_current_line(137, ng0);
    t2 = (t0 + 528U);
    t3 = xsi_signal_has_event(t2);
    if (t3 == 1)
        goto LAB5;

LAB6:    t1 = (unsigned char)0;

LAB7:    if (t1 != 0)
        goto LAB2;

LAB4:
LAB3:    t2 = (t0 + 4980);
    *((int *)t2) = 1;

LAB1:    return;
LAB2:    xsi_set_current_line(138, ng0);
    t4 = (t0 + 636U);
    t8 = *((char **)t4);
    t9 = *((unsigned char *)t8);
    t10 = (t9 == (unsigned char)3);
    if (t10 != 0)
        goto LAB8;

LAB10:    xsi_set_current_line(142, ng0);
    t2 = (t0 + 2396U);
    t4 = *((char **)t2);
    t2 = (t0 + 7736U);
    t5 = (t0 + 2308U);
    t8 = *((char **)t5);
    t5 = (t0 + 7720U);
    t1 = ieee_std_logic_unsigned_equal_stdv_stdv(IEEE_P_3620187407, t4, t2, t8, t5);
    if (t1 != 0)
        goto LAB11;

LAB13:    xsi_set_current_line(145, ng0);
    t2 = (t0 + 5444);
    t4 = (t2 + 32U);
    t5 = *((char **)t4);
    t8 = (t5 + 32U);
    t11 = *((char **)t8);
    *((unsigned char *)t11) = (unsigned char)2;
    xsi_driver_first_trans_fast_port(t2);

LAB12:    xsi_set_current_line(148, ng0);
    t2 = (t0 + 2484U);
    t4 = *((char **)t2);
    t2 = (t0 + 7752U);
    t5 = (t0 + 2308U);
    t8 = *((char **)t5);
    t5 = (t0 + 7720U);
    t1 = ieee_std_logic_unsigned_equal_stdv_stdv(IEEE_P_3620187407, t4, t2, t8, t5);
    if (t1 != 0)
        goto LAB14;

LAB16:    xsi_set_current_line(151, ng0);
    t2 = (t0 + 5480);
    t4 = (t2 + 32U);
    t5 = *((char **)t4);
    t8 = (t5 + 32U);
    t11 = *((char **)t8);
    *((unsigned char *)t11) = (unsigned char)2;
    xsi_driver_first_trans_fast(t2);

LAB15:
LAB9:    goto LAB3;

LAB5:    t4 = (t0 + 548U);
    t5 = *((char **)t4);
    t6 = *((unsigned char *)t5);
    t7 = (t6 == (unsigned char)3);
    t1 = t7;
    goto LAB7;

LAB8:    xsi_set_current_line(139, ng0);
    t4 = (t0 + 5444);
    t11 = (t4 + 32U);
    t12 = *((char **)t11);
    t13 = (t12 + 32U);
    t14 = *((char **)t13);
    *((unsigned char *)t14) = (unsigned char)2;
    xsi_driver_first_trans_fast_port(t4);
    xsi_set_current_line(140, ng0);
    t2 = (t0 + 5480);
    t4 = (t2 + 32U);
    t5 = *((char **)t4);
    t8 = (t5 + 32U);
    t11 = *((char **)t8);
    *((unsigned char *)t11) = (unsigned char)2;
    xsi_driver_first_trans_fast(t2);
    goto LAB9;

LAB11:    xsi_set_current_line(143, ng0);
    t11 = (t0 + 5444);
    t12 = (t11 + 32U);
    t13 = *((char **)t12);
    t14 = (t13 + 32U);
    t15 = *((char **)t14);
    *((unsigned char *)t15) = (unsigned char)3;
    xsi_driver_first_trans_fast_port(t11);
    goto LAB12;

LAB14:    xsi_set_current_line(149, ng0);
    t11 = (t0 + 5480);
    t12 = (t11 + 32U);
    t13 = *((char **)t12);
    t14 = (t13 + 32U);
    t15 = *((char **)t14);
    *((unsigned char *)t15) = (unsigned char)3;
    xsi_driver_first_trans_fast(t11);
    goto LAB15;

}

static void work_a_3643194780_3212880686_p_9(char *t0)
{
    char *t1;
    char *t2;
    unsigned char t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;
    char *t8;

LAB0:    xsi_set_current_line(156, ng0);

LAB3:    t1 = (t0 + 2748U);
    t2 = *((char **)t1);
    t3 = *((unsigned char *)t2);
    t1 = (t0 + 5516);
    t4 = (t1 + 32U);
    t5 = *((char **)t4);
    t6 = (t5 + 32U);
    t7 = *((char **)t6);
    *((unsigned char *)t7) = t3;
    xsi_driver_first_trans_fast_port(t1);

LAB2:    t8 = (t0 + 4988);
    *((int *)t8) = 1;

LAB1:    return;
LAB4:    goto LAB2;

}

static void work_a_3643194780_3212880686_p_10(char *t0)
{
    unsigned char t1;
    char *t2;
    unsigned char t3;
    char *t4;
    char *t5;
    unsigned char t6;
    unsigned char t7;
    char *t8;
    unsigned char t9;
    char *t10;
    char *t11;
    char *t12;
    char *t13;

LAB0:    xsi_set_current_line(160, ng0);
    t2 = (t0 + 528U);
    t3 = xsi_signal_has_event(t2);
    if (t3 == 1)
        goto LAB5;

LAB6:    t1 = (unsigned char)0;

LAB7:    if (t1 != 0)
        goto LAB2;

LAB4:
LAB3:    t2 = (t0 + 4996);
    *((int *)t2) = 1;

LAB1:    return;
LAB2:    xsi_set_current_line(161, ng0);
    t4 = (t0 + 2748U);
    t8 = *((char **)t4);
    t9 = *((unsigned char *)t8);
    t4 = (t0 + 5552);
    t10 = (t4 + 32U);
    t11 = *((char **)t10);
    t12 = (t11 + 32U);
    t13 = *((char **)t12);
    *((unsigned char *)t13) = t9;
    xsi_driver_first_trans_fast(t4);
    goto LAB3;

LAB5:    t4 = (t0 + 548U);
    t5 = *((char **)t4);
    t6 = *((unsigned char *)t5);
    t7 = (t6 == (unsigned char)3);
    t1 = t7;
    goto LAB7;

}

static void work_a_3643194780_3212880686_p_11(char *t0)
{
    unsigned char t1;
    char *t2;
    unsigned char t3;
    char *t4;
    char *t5;
    unsigned char t6;
    unsigned char t7;
    char *t8;
    unsigned char t9;
    unsigned char t10;
    unsigned char t11;
    char *t12;
    unsigned char t13;
    unsigned char t14;
    char *t15;
    unsigned char t16;
    unsigned char t17;
    char *t18;
    char *t19;
    char *t20;
    char *t21;

LAB0:    xsi_set_current_line(167, ng0);
    t2 = (t0 + 528U);
    t3 = xsi_signal_has_event(t2);
    if (t3 == 1)
        goto LAB5;

LAB6:    t1 = (unsigned char)0;

LAB7:    if (t1 != 0)
        goto LAB2;

LAB4:
LAB3:    t2 = (t0 + 5004);
    *((int *)t2) = 1;

LAB1:    return;
LAB2:    xsi_set_current_line(168, ng0);
    t4 = (t0 + 1780U);
    t8 = *((char **)t4);
    t9 = *((unsigned char *)t8);
    t10 = (t9 == (unsigned char)5);
    if (t10 != 0)
        goto LAB8;

LAB10:
LAB9:    goto LAB3;

LAB5:    t4 = (t0 + 548U);
    t5 = *((char **)t4);
    t6 = *((unsigned char *)t5);
    t7 = (t6 == (unsigned char)3);
    t1 = t7;
    goto LAB7;

LAB8:    xsi_set_current_line(169, ng0);
    t4 = (t0 + 2748U);
    t12 = *((char **)t4);
    t13 = *((unsigned char *)t12);
    t14 = (t13 == (unsigned char)2);
    if (t14 == 1)
        goto LAB14;

LAB15:    t11 = (unsigned char)0;

LAB16:    if (t11 != 0)
        goto LAB11;

LAB13:    xsi_set_current_line(172, ng0);
    t2 = (t0 + 5588);
    t4 = (t2 + 32U);
    t5 = *((char **)t4);
    t8 = (t5 + 32U);
    t12 = *((char **)t8);
    *((unsigned char *)t12) = (unsigned char)2;
    xsi_driver_first_trans_fast(t2);

LAB12:    goto LAB9;

LAB11:    xsi_set_current_line(170, ng0);
    t4 = (t0 + 5588);
    t18 = (t4 + 32U);
    t19 = *((char **)t18);
    t20 = (t19 + 32U);
    t21 = *((char **)t20);
    *((unsigned char *)t21) = (unsigned char)3;
    xsi_driver_first_trans_fast(t4);
    goto LAB12;

LAB14:    t4 = (t0 + 2836U);
    t15 = *((char **)t4);
    t16 = *((unsigned char *)t15);
    t17 = (t16 == (unsigned char)3);
    t11 = t17;
    goto LAB16;

}


extern void work_a_3643194780_3212880686_init()
{
	static char *pe[] = {(void *)work_a_3643194780_3212880686_p_0,(void *)work_a_3643194780_3212880686_p_1,(void *)work_a_3643194780_3212880686_p_2,(void *)work_a_3643194780_3212880686_p_3,(void *)work_a_3643194780_3212880686_p_4,(void *)work_a_3643194780_3212880686_p_5,(void *)work_a_3643194780_3212880686_p_6,(void *)work_a_3643194780_3212880686_p_7,(void *)work_a_3643194780_3212880686_p_8,(void *)work_a_3643194780_3212880686_p_9,(void *)work_a_3643194780_3212880686_p_10,(void *)work_a_3643194780_3212880686_p_11};
	xsi_register_didat("work_a_3643194780_3212880686", "isim/_tmp/work/a_3643194780_3212880686.didat");
	xsi_register_executes(pe);
}
