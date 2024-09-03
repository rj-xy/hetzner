# Terraform Vultr Provider

https://registry.terraform.io/providers/vultr/vultr/latest/docs

Ping Test: https://cloudpingtest.com/vultr

```bash
VULTR_REGIONS=$(curl "https://api.vultr.com/v2/regions" -X GET)
echo $VULTR_REGIONS | jq '.regions[] | select(.city | contains("Singapore"))'
```

= Plans - location includes "fra" (France), "syd" (Sydney), "jnb" (Johannesburg) "sgp" (Singapore)

```bash
VULTR_PLANS=$(curl "https://api.vultr.com/v2/plans" -X GET)
echo $VULTR_PLANS | jq '.plans[] | select(.locations[] | contains("sgp"))'


echo $VULTR_PLANS | jq '.plans[] | select(.monthly_cost <= 20) | select(.vcpu_count >= 2) | select(.locations[] | contains("sgp")) | del(.locations)'
```

<!--
11	Australia (Sydney)	syd-au	        21 ms	21 ms	21 ms	21 ms	21 ms
10	Australia (Melbourne)	mel-au	    30 ms	30 ms	30 ms	30 ms	30 ms
7	Singapore (Singapore)	sgp	        112 ms	112 ms	112 ms	112 ms	112 ms
6	South Korea (Seoul)	sel-kor	        200 ms	200 ms	200 ms	200 ms	200 ms
2	India (Bangalore)	blr-in	        203 ms	203 ms	203 ms	203 ms	203 ms
9	Japan (Tokyo)	hnd-jp	            203 ms	203 ms	203 ms	203 ms	203 ms
3	India (Delhi NCR)	del-in	        204 ms	204 ms	204 ms	204 ms	204 ms
4	India (Mumbai)	bom-in	            204 ms	204 ms	204 ms	204 ms	204 ms
5	Japan (Osaka)	osk-jp	            206 ms	206 ms	206 ms	206 ms	206 ms
1	Africa (Johannesburg)	jnb-za	    304 ms	304 ms	304 ms	304 ms	304 ms
13	Germany (Frankfurt)	fra-de	        304 ms	304 ms	304 ms	304 ms	304 ms
14	United Kingdom (London)	lon-gb	    306 ms	306 ms	306 ms	306 ms	306 ms
15	Spain (Madrid)	mad-es	            306 ms	306 ms	306 ms	306 ms	306 ms
16	United Kingdom (Manchester)	man-uk	353 ms	353 ms	353 ms	353 ms	353 ms
8	Israel (Tel Aviv)	tlv-il	        399 ms	399 ms	399 ms	399 ms	399 ms
12	Netherlands (Amsterdam)	ams-nl	    562 ms	562 ms	562 ms	562 ms	562 ms
29	USA (Silicon Valley)	sjo-ca-us	274 ms	274 ms	274 ms	274 ms	274 ms
24	USA (Los Angeles)	lax-ca-us	    496 ms	496 ms	496 ms	496 ms	496 ms
20	USA (Atlanta)	ga-us	            256 ms	256 ms	256 ms	256 ms	256 ms
23	USA (Honolulu)	hon-hi-us	        207 ms	207 ms	207 ms	207 ms	207 ms
21	USA (Chicago)	il-us	            260 ms	260 ms	260 ms	260 ms	260 ms
25	Mexico (Mexico City)	mex-mx	    210 ms	210 ms	210 ms	210 ms	210 ms
22	United States (Dallas)	tx-us	    295 ms	295 ms	295 ms	295 ms	295 ms
28	United States (Seattle)	wa-us	    235 ms	235 ms	235 ms	235 ms	235 ms
17	France (Paris)	par-fr	            463 ms	463 ms	463 ms	463 ms	463 ms
18	Sweden (Stockholm)	sto-se	304 ms	304 ms	304 ms	304 ms	304 ms
27	United States (New Jersey)	nj-us	306 ms	306 ms	306 ms	306 ms	306 ms
30	Canada (Toronto)	tor-ca	307 ms	307 ms	307 ms	307 ms	307 ms
31	Chile (Santiago)	scl-cl	309 ms	309 ms	309 ms	309 ms	309 ms
26	United States (Miami)	fl-us	315 ms	315 ms	315 ms	315 ms	315 ms
19	Poland (Warsaw)	waw-pl	306 ms	306 ms	306 ms	306 ms	306 ms
32	Brazil (São Paulo)	sao-br	334 ms	334 ms	334 ms	334 ms	334 ms
-->
