#### test1 ####
#for i in range(1,5):
#    for j in range(1,5):
#        for k in range(1,5):
#            if (i!=j) and (j!=k) and (i!=k):
#                
#                print(i,j,k)


#### test2 ####


l=int(input("please input l"))


if l >=100000:
    reward=l/10
elif 10<= l <= 200000:
    reward=10000+0.75*(l-100000)
else:
    reward=1000000

print (reward)

